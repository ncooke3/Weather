//
//  DarkSky.m
//  DarkSkyNetworking
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DarkSky.h"
#import "NSArray+URLValidExclusionsParameter.h"


@implementation DarkSky {
    NSUserDefaults *userDefaults;
    //dispatch_queue_t queue;
}


# pragma mark - Singleton Methods

+ (id)sharedManagager {
    static DarkSky *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];

        self.apiKey = @"0e7f5038c7db684db9d0cafe2ad2ee69"; // ⚠️ API KEY exposed
        
        self.cacheEnabled = YES;
        self.cacheExpirationInMinutes = 30;
        
        self.cacheQueue = dispatch_queue_create("com.ncooke.DSCacheQueue", NULL);
        
    }
    return self;
}

# pragma mark - Instance Methods

- (void)getForecastForLatitude:(double)latitude
                     longitude:(double)longitude
                          time:(NSNumber *)time
                     excluding:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)language
                         units:(NSString *)units
                       success:(void (^)(NSDictionary *JSON))success
                       failure:(void (^)(NSError *error, id response))failure {
    
    [self checkForAPIKey];

    NSString *urlString = [self urlStringWithLatitude:latitude longitude:longitude time:time excluding:exclusions extend:extendCommand language:language units:units];
    
    NSString *urlCacheKey = [self cacheKeyWithUrlString:urlString latitude:latitude longitude:longitude];
    
    [self checkCacheForCachedForecastWithUrlCacheKey:urlCacheKey success:^(NSDictionary *cachedForecast) {
        success(cachedForecast);
        
    } error:^(NSError *error) {
        
        NSURL *url = [NSURL URLWithString:urlString];
         
        NSMutableURLRequest *mutablRequest = [NSMutableURLRequest requestWithURL:url];
        mutablRequest.HTTPMethod = @"GET";
        NSURLRequest *request = [mutablRequest copy];
         

        NSURLSession *sharedSession = [NSURLSession sharedSession];
         
        NSURLSessionDataTask *task;
        
        task = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
            
            if (error) {
                failure(error, response);
            }
            
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

            if (self.cacheEnabled) {
                [self cacheForecast:json withURLString:urlCacheKey];
            }
            success(json);
            
         }];
        
        [task resume];

    }];

}

- (void)clearCache {
    [userDefaults removeObjectForKey:kDSCacheKey];
}

# pragma mark - Private Methods

// MARK: migrate to third party cacheing library before launching
- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString {

    dispatch_async(self.cacheQueue, ^{
        NSMutableDictionary *cachedForecasts = [[self->userDefaults objectForKey:kDSCacheKey] mutableCopy];
        if (!cachedForecasts) {
            cachedForecasts = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:self.cacheExpirationInMinutes * 60];
        
        NSDictionary<NSString *, id>*cacheItem = @{kDSCacheForecastKey:forecast, kDSCacheExpiresKey:expirationDate};

        [cachedForecasts setObject:cacheItem forKeyedSubscript:urlString];
        [self->userDefaults setObject:cachedForecasts forKey:kDSCacheKey];
    });
}


- (void)checkCacheForCachedForecastWithUrlCacheKey:(NSString *)urlCacheKey
                                         success:(void (^)(NSDictionary *cachedForecast))success
                                           error:(void (^)(NSError *error))failure {
    
    if (!self.cacheEnabled) {
        failure([NSError errorWithDomain:kDSErrorDomain code:kDSCacheNotEnabled userInfo:nil]);
    }

    dispatch_async(self.cacheQueue, ^{
        
        BOOL cacheItemWasFound = NO;
        
        // TODO: ask Jonathan about warning below
        // TODO: would any of this need to be wrapped in a try catch?
        NSDictionary<NSString *, id> *cachedForecasts = [self->userDefaults objectForKey:kDSCacheKey];
        if (cachedForecasts) {
            
            NSDictionary<NSString *, id> *archivedCacheData = [cachedForecasts objectForKey:urlCacheKey];
            if (archivedCacheData) {
                
                NSDate *expirationDate = (NSDate *)[archivedCacheData objectForKey:kDSCacheExpiresKey];
                NSDate *currentDate = [NSDate date];
                
                if ([currentDate compare:expirationDate] == NSOrderedAscending) {
                    cacheItemWasFound = YES;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        success([archivedCacheData objectForKey:kDSCacheForecastKey]);
                    });
                }
            }
            
        }
        
        if (!cacheItemWasFound) {
            dispatch_async(self.cacheQueue, ^{
                failure([NSError errorWithDomain:kDSErrorDomain code:kDSCacheItemNotFound userInfo:nil]);
            });
        }
        
    });

}


- (NSString *)cacheKeyWithUrlString:(NSString *)urlString
                                 latitude:(double)latitude
                                longitude:(double)longitude {
    
    NSString *currentSpecificLocation = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSString *generalizedLocation = [NSString stringWithFormat:@"%.2f,@%.2f", latitude, longitude];
    return [urlString stringByReplacingOccurrencesOfString:currentSpecificLocation withString:generalizedLocation];
}

- (NSString *)urlStringWithLatitude:(double)latitude
                          longitude:(double)longitude
                               time:(NSNumber *)time
                          excluding:(NSArray *)exclusions
                             extend:(NSString *)extendCommand
                           language:(NSString *)language
                              units:(NSString *)units {
    
    NSMutableString *urlString = [NSMutableString stringWithString:darkSkyBaseURL];
    [urlString appendFormat:@"%@/%.6f,%.6f", self.apiKey, latitude, longitude];
    if (time) [urlString appendFormat:@",%.0f", time.doubleValue];
    if (exclusions) [urlString appendFormat:@"?exclude=%@", [exclusions convertToValidURLParameterString]];
    if (extendCommand) [urlString appendFormat:@"%@extend=%@", exclusions ? @"&" : @"?", extendCommand];
    if (language) [urlString appendFormat:@"%@lang=%@", (exclusions || extendCommand) ? @"&" : @"?", language];
    if (units) [urlString appendFormat:@"%@units=%@", (exclusions || extendCommand || language) ? @"&" : @"?", units];

    return urlString;
    
}


- (void)checkForAPIKey {
    if (!self.apiKey || ![self.apiKey length]) {
        NSException *missingAPIKeyException = [NSException exceptionWithName:@"Missing API Key" reason:@"Please add an API key to make requests." userInfo:nil];
        @throw missingAPIKeyException;
    }
}

@end


@implementation NSArray (URLValidExclusionsParameter)

- (NSString *)convertToValidURLParameterString {
    __block NSString *validURLParameterString = [NSString new]; // marks variable as able to be changed within block
    [self enumerateObjectsUsingBlock:^(id  exclusion, NSUInteger index, BOOL * stop) {
        validURLParameterString = [validURLParameterString stringByAppendingFormat: index == 0 ? @"%@" : @",%@", exclusion];
    }];
    return validURLParameterString;
}

@end
