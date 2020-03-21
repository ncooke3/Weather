//
//  ForecastModelTests.m
//  WeatherTests
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CurrentForecast.h"
#import "DarkSky.h"


@interface ForecastModelTests : XCTestCase

@end

@implementation ForecastModelTests {
    DarkSky             *darkSky;
}

- (void)setUp {
    darkSky = [DarkSky sharedManagager];
    [darkSky clearCache];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitWithNilDictionary {
    NSDictionary *mockForecastJSON = nil;
    CurrentForecast *currentForecast = [[CurrentForecast alloc] initWithDictionary:mockForecastJSON];
    XCTAssert(currentForecast != nil);
    XCTAssert([currentForecast isKindOfClass:[CurrentForecast class]]);
}

- (void)testInitWithIncompleteDictionary {
    NSDictionary *mockForecastJSON = @{
        @"time": @(123456),
        // @"icon": @"snow" // missing field
        @"nearestStormDistance": @(240),
        // @"nearestStormBearing": // missing field
        @"precipProbability": @(0.16),
        @"precipIntensity": @(0.01),
        @"precipType": @"snow",
        @"humidity": @(0.95),
        @"pressure": @(300),
        // @"windSpeed": // missing field
    };
    CurrentForecast *currentForecast = [[CurrentForecast alloc] initWithDictionary:mockForecastJSON];
    XCTAssert(currentForecast != nil);
    XCTAssert([currentForecast isKindOfClass:[CurrentForecast class]]);
    XCTAssert(currentForecast.time != nil);
    XCTAssert(currentForecast.icon == nil); // since it is missing
    XCTAssert(currentForecast.nearestStormDistance.intValue == 240);
    XCTAssert(currentForecast.nearestStormBearing == nil); // since it is missing
    XCTAssert(currentForecast.precipProbability.doubleValue == 0.16);
    XCTAssert(currentForecast.precipIntensity.doubleValue == 0.01);
    XCTAssert([currentForecast.precipType isEqualToString:@"snow"]);
    XCTAssert(currentForecast.humidity.doubleValue == 0.95);
    XCTAssert(currentForecast.pressure.doubleValue == 300);
    XCTAssert(currentForecast.windSpeed.doubleValue == 0); // since it is missing
}

- (void)testValidCurrentForecast {
    XCTestExpectation *validCurrentForecast = [self expectationWithDescription:@"valid forecast"];
    
    __block CurrentForecast *currentForecast = nil;
    XCTAssert(currentForecast == nil);
    
    double latitude = 42.3601;
    double longitude = -71.0589;
    int time = 1509993277;

    [darkSky getForecastForLatitude:latitude longitude:longitude time:@(time) excluding:nil extend:@"" language:@"" units:@"us" success:^(NSDictionary *forecastJSON) {
        XCTAssert(forecastJSON != nil);
        currentForecast = [[CurrentForecast alloc] initWithDictionary:forecastJSON[kDScurrentlyForecast]];
        [validCurrentForecast fulfill];
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [error description]);
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        XCTAssert(error == nil);
        XCTAssert([currentForecast isKindOfClass:[CurrentForecast class]]);
        XCTAssert(currentForecast.time.intValue == time);
        XCTAssert([currentForecast.icon isEqualToString:@"rain"]);
        XCTAssert(currentForecast.nearestStormDistance.intValue == 0);
        XCTAssert(currentForecast.nearestStormBearing == nil);
        XCTAssert(currentForecast.precipProbability.doubleValue == 0.38);
        XCTAssert(currentForecast.precipIntensity.doubleValue == 0.0015);
        XCTAssert([currentForecast.precipType isEqualToString:@"rain"]);
        XCTAssert(currentForecast.humidity.doubleValue == 0.89);
        XCTAssert(currentForecast.pressure.doubleValue == 1009.6);
        XCTAssert(currentForecast.windSpeed.doubleValue == 2.19);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self testValidCurrentForecast];
    }];
}

@end
