//
//  DarkSkyConstants.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const darkSkyBaseURL;

extern NSString* const kDSErrorDomain;

typedef NS_ENUM(NSInteger, kDSErrors) {
    kDSCacheItemNotFound,
    kDSCacheNotEnabled
};

// TODO: Caches Keys
extern NSString* const kDSCacheKey;
extern NSString* const kDSNetworkCacheKey;
extern NSString* const kDSCacheExpiresKey;
extern NSString* const kDSCacheForecastKey;

// Unit Types
extern NSString* const kDSUSUnits;
extern NSString* const kDSSIUnits;
extern NSString* const kDSUKUnits;
extern NSString* const kDSCAUnits;
extern NSString* const kDSAutoUnits;

// Languages
extern NSString* const kDSLanguageDutch;
extern NSString* const kDSLanguageEnglish;
extern NSString* const kDSLanguageFrench;
extern NSString* const kDSLanguageGerman;
extern NSString* const kDSLanguageGreek;
extern NSString* const kDSLanguageSpanish;


// Extend types
extern NSString* const kDSExtendHourly;


// Response Object Keys
extern NSString* const kDSlatitude;
extern NSString* const kDSlongitude;
extern NSString* const kDStimezone;

extern NSString* const kDScurrentlyForecast;
extern NSString* const kDSminutelyForecast;
extern NSString* const kDShourlyForecast;
extern NSString* const kDSdailyForecast;

extern NSString* const kDSalerts;
extern NSString* const kDSflags;


// Data Point Object Keys
extern NSString* const kDSApparentTemperature;
extern NSString* const kDSApparentTemperatureHigh;
extern NSString* const kDSApparentTemperatureHighTime;
extern NSString* const kDSApparentTemperatureLow;
extern NSString* const kDSApparentTemperatureLowTime;
extern NSString* const kDSApparentTemperatureMax;
extern NSString* const kDSApparentTemperatureMaxTime;
extern NSString* const kDSApparentTemperatureMin;
extern NSString* const kDSApparentTemperatureMinTime;
extern NSString* const kDSCloudCover;
extern NSString* const kDSDewPoint;
extern NSString* const kDSHumidity;
extern NSString* const kDSIcon;
extern NSString* const kDSMoonPhase;
extern NSString* const kDSNearestStormBearing;
extern NSString* const kDSNearestStormDistance;
extern NSString* const kDSOzone;
extern NSString* const kDSPrecipAcculumation;
extern NSString* const kDSPrecipIntensity;
extern NSString* const kDSPrecipIntensityError;
extern NSString* const kDSPrecipIntensityMax;
extern NSString* const kDSPrecipIntensityMaxTime;
extern NSString* const kDSPrecipProbability;
extern NSString* const kDSPrecipType;
extern NSString* const kDSPressure;
extern NSString* const kDSSummary;
extern NSString* const kDSSunriseTime;
extern NSString* const kDSSunsetTime;
extern NSString* const kDSTemperature;
extern NSString* const kDSTemperatureHigh;
extern NSString* const kDSTemperatureHighTime;
extern NSString* const kDSTemperatureLow;
extern NSString* const kDSTemperatureLowTime;
extern NSString* const kDSTemperatureMax;
extern NSString* const kDSTemperatureMin;
extern NSString* const kDSTemperatureMinTime;
extern NSString* const kDSTime;
extern NSString* const kDSUvIndex;
extern NSString* const kDSUvIndexTime;
extern NSString* const kDSVisibility;
extern NSString* const kDSWindBearing;
extern NSString* const kDSWindGust;
extern NSString* const kDSWindGustTime;
extern NSString* const kDSWindSpeed;

// Data Block Object Keys
extern NSString* const kDSData;
extern NSString* const kDSSummary;
extern NSString* const kDSIcon;

// Icon Conditions
extern NSString* const kDSclearDay;
extern NSString* const kDSclearNight;
extern NSString* const kDScloudy;
extern NSString* const kDSfog;
extern NSString* const kDShail;
extern NSString* const kDSpartlyCloudyDay;
extern NSString* const kDSpartlyCloudyNight;
extern NSString* const kDSrain;
extern NSString* const kDSsleet;
extern NSString* const kDSsnow;
extern NSString* const kDSthunderstorm;
extern NSString* const kDStornado;
extern NSString* const kDSwind;

// TODO: Alerts Object Keys

// TODO: Flags Object Keys

NS_ASSUME_NONNULL_END
