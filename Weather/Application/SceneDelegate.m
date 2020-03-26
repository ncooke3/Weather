#import "SceneDelegate.h"
#import "WeatherController.h"

@interface SceneDelegate ()

@property (strong, nonatomic) WeatherController *mainViewController;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
    self.window = [[UIWindow alloc] initWithFrame:windowScene.coordinateSpace.bounds];
    self.mainViewController = [WeatherController new];
    self.window.windowScene = windowScene;
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        [self.mainViewController.locationManager stopUpdatingLocation];
        [self.mainViewController.locationManager startMonitoringSignificantLocationChanges];
    } else {
        NSLog(@"Significant location change monitoring is not available.");
    }
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        [self.mainViewController.locationManager stopMonitoringSignificantLocationChanges];
        [self.mainViewController.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Significant location change monitoring is not available.");
    }
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
