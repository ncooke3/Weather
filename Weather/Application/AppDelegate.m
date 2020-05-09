//
//  AppDelegate.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "AppDelegate.h"
#import <BackgroundTasks/BackgroundTasks.h>

// Frameworks
#import "DarkSky.h"
#import <Cashier/NOPersistentStore.h>

// Models
#import "Forecast.h"

static NSString *backgroundTaskIdentifier = @"com.ncooke.refreshForecasts";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationBar.appearance.backgroundColor = UIColor.systemBackgroundColor;
    
    [BGTaskScheduler.sharedScheduler registerForTaskWithIdentifier:backgroundTaskIdentifier usingQueue:nil launchHandler:^(__kindof BGTask * _Nonnull task) {
        [self handleAppRefresh:(BGAppRefreshTask *)task];
    }];
    
    return YES;
}

#pragma mark - Scheduling Tasks

- (void)scheduleAppRefresh {
    BGAppRefreshTaskRequest *request = [[BGAppRefreshTaskRequest alloc] initWithIdentifier:backgroundTaskIdentifier];
    request.earliestBeginDate = [NSDate dateWithTimeIntervalSinceNow: 30 * 60]; // Fetch no earlier than 30 min from now
    
    NSError *error = nil;
    [BGTaskScheduler.sharedScheduler submitTaskRequest:request error:&error];
    if (error) {
        NSLog(@"Could not schedule app refresh: %@", [error localizedDescription]);
    }
    
}

#pragma mark - Handling Launch for Tasks

- (void)handleAppRefresh:(BGAppRefreshTask *)task {
    
    __block BOOL success = YES;
    
    task.expirationHandler = ^{
        [[DarkSky sharedManagager] cancelAllRequests];
        success = NO;
    };
    
    NOPersistentStore *weatherCache = [NOPersistentStore cacheWithId:@"persistentStoreId"];
    NSArray<Forecast *> *cityForecasts = [weatherCache objectForKey:@"forecasts"];

    dispatch_group_t forecastGroup = dispatch_group_create();
    
    for (NSInteger index = 0; index < [cityForecasts count]; index++) {
        Forecast *forecast = [cityForecasts objectAtIndex:index];
        dispatch_group_enter(forecastGroup);
        [forecast updateForecasts:^{
            NSDictionary *info = @{@"forecast": forecast, @"index": @(index)};
            [NSNotificationCenter.defaultCenter postNotificationName:@"com.ncooke.newForecastFetched" object:self userInfo:info];
            dispatch_group_leave(forecastGroup);
        }];
    }
    
    dispatch_group_notify(forecastGroup, dispatch_get_main_queue(), ^{
        if (success) [weatherCache setObject:cityForecasts forKey:@"forecasts"];
        [task setTaskCompletedWithSuccess:success];
    });
    
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    
}


@end
