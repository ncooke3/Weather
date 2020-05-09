//
//  DarkSky.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DarkSkyConstants.h"


#pragma mark - DarkSky Interface Declaration

@interface DarkSky : NSObject

@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSString *units;

@property (nonatomic) BOOL cacheEnabled;
@property (nonatomic) int cacheExpirationInMinutes;

@property (nonatomic, strong) dispatch_queue_t cacheQueue;


+ (id)sharedManagager;

// TODO: refactor with a completion block typedef declared in header file
//       -> look up how to split the typedef'd completion into success and error?
//       -> read the Appple docs on blocks YEET
- (void)getForecastForLatitude:(double)latitude
                     longitude:(double)longitude
                          time:(NSNumber *)time
                     excluding:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)language
                         units:(NSString *)units
                       success:(void (^)(NSDictionary *JSON))success
                       failure:(void (^)(NSError *error, id response))failure;


- (void)checkForAPIKey;

- (NSString *)urlStringWithLatitude:(double)latitude
                          longitude:(double)longitude
                               time:(NSNumber *)time
                          excluding:(NSArray *)exclusions
                             extend:(NSString *)extendCommand
                           language:(NSString *)language
                              units:(NSString *)units;

// TODO: cancelRequests

- (NSString *)cacheKeyWithUrlString:(NSString *)urlString
                           latitude:(double)latitude
                          longitude:(double)longitude;

- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString;

- (void)clearCache;

- (void)cancelAllRequests;

- (void)checkCacheForCachedForecastWithUrlCacheKey:(NSString *)urlCacheKey
                                           success:(void (^)(NSDictionary *cachedForecast))success
                                             error:(void (^)(NSError *error))failure;
                    

@end

