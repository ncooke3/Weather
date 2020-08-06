//
//  DarkSky.m
//  DarkSkyNetworking
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DarkSky.h"
#import "NSArray+URLValidExclusionsParameter.h"

// Frameworks
#import <Cashier/Cashier.h>

@interface DarkSky ()

@property (nonatomic) Cashier *cache;

@end

@implementation DarkSky {
    NSUserDefaults *userDefaults;
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
        _cache = [Cashier cacheWithId:@"network"];
        _cache.lifespan = 60 * 30;
        _cache.returnsExpiredData = NO;
        self.apiKey = @"0e7f5038c7db684db9d0cafe2ad2ee69"; // ⚠️ This key has since been deactivated.
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
//    [userDefaults removeObjectForKey:kDSCacheKey];
    [_cache clearAllData];
}

- (void)cancelAllRequests {
    [[NSURLSession sharedSession] invalidateAndCancel];
}

# pragma mark - Private Methods

- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString {
    dispatch_async(self.cacheQueue, ^{
        [self.cache setObject:forecast forKey:urlString];
    });
}


- (void)checkCacheForCachedForecastWithUrlCacheKey:(NSString *)urlCacheKey
                                         success:(void (^)(NSDictionary *cachedForecast))success
                                           error:(void (^)(NSError *error))failure {
    dispatch_async(self.cacheQueue, ^{
       if (!self.cacheEnabled) {
           failure([NSError errorWithDomain:kDSErrorDomain code:kDSCacheNotEnabled userInfo:nil]);
       }
         
       NSDictionary *cachedForecast = [self.cache objectForKey:urlCacheKey];
       if (cachedForecast) {
           success(cachedForecast);
       } else {
           failure([NSError errorWithDomain:kDSErrorDomain code:kDSCacheItemNotFound userInfo:nil]);
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
