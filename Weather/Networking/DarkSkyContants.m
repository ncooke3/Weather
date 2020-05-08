//
//  DarkSkyConstants.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DarkSkyConstants.h"

NSString* const kDSErrorDomain = @"com.darksky.errors";

// TODO: is there a better way to store this?
NSString* const darkSkyBaseURL = @"https://api.darksky.net/forecast/";

// TODO: Caches Keys
NSString* const kDSCacheKey = @"Cached Forecasts";
NSString* const kDSNetworkCacheKey = @"Network Cache";
NSString* const kDSCacheExpiresKey = @"ExpiresAt";
NSString* const kDSCacheForecastKey = @"Forecast";


// Unit Types
NSString* const kDSUSUnits   = @"us";
NSString* const kDSSIUnits   = @"si";
NSString* const kDSUKUnits   = @"uk2";
NSString* const kDSCAUnits   = @"ca";
NSString* const kDSAutoUnits = @"auto";

// Languages
NSString* const kDSLanguageDutch   = @"nl";
NSString* const kDSLanguageEnglish = @"en";
NSString* const kDSLanguageFrench  = @"fr";
NSString* const kDSLanguageGerman  = @"de";
NSString* const kDSLanguageGreek   = @"el";
NSString* const kDSLanguageSpanish = @"es";

// Extend types
NSString* const kDSExtendHourly = @"hourly";

// Response Object Keys
NSString* const kDSlatitude          = @"latitude";
NSString* const kDSlongitude         = @"longitude";
NSString* const kDStimezone          = @"timezone";
NSString* const kDScurrentlyForecast = @"currently";
NSString* const kDSminutelyForecast  = @"minutely";
NSString* const kDShourlyForecast    = @"hourly";
NSString* const kDSdailyForecast     = @"daily";
NSString* const kDSalerts            = @"alerts";
NSString* const kDSflags             = @"flags";

// Data Point Object Keys
NSString* const kDSApparentTemperature         = @"apparentTemperature";
NSString* const kDSApparentTemperatureHigh     = @"apparentTemperatureHigh";
NSString* const kDSApparentTemperatureHighTime = @"apparentTemperatureHighTime";
NSString* const kDSApparentTemperatureLow      = @"apparentTemperatueLow";
NSString* const kDSApparentTemperatureLowTime  = @"apparentTemperatureLowTime";
NSString* const kDSApparentTemperatureMax      = @"apparentTemperatureMax";
NSString* const kDSApparentTemperatureMaxTime  = @"apparentTemperatureMaxTime";
NSString* const kDSApparentTemperatureMin      = @"apparentTemperatureMin";
NSString* const kDSApparentTemperatureMinTime  = @"apparentTemperatureMinTime";
NSString* const kDSCloudCover                  = @"cloudCover";
NSString* const kDSDewPoint                    = @"dewPoint";
NSString* const kDSHumidity                    = @"humidity";
NSString* const kDSIcon                        = @"icon";
NSString* const kDSMoonPhase                   = @"moonPhase";
NSString* const kDSNearestStormBearing         = @"nearestStormBearing";
NSString* const kDSNearestStormDistance        = @"nearestStormDistance";
NSString* const kDSOzone                       = @"ozone";
NSString* const kDSPrecipAccumulation          = @"precipAccumulation";
NSString* const kDSPrecipIntensity             = @"precipIntensity";
NSString* const kDSPrecipIntensityError        = @"precipIntensityError";
NSString* const kDSPrecipIntensityMax          = @"precipIntensityMax";
NSString* const kDSPrecipIntensityMaxTime      = @"precipIntensityMaxTime";
NSString* const kDSPrecipProbability           = @"precipProbability";
NSString* const kDSPrecipType                  = @"precipType";
NSString* const kDSPressure                    = @"pressure";
NSString* const kDSSummary                     = @"summary";
NSString* const kDSSunriseTime                 = @"sunriseTime";
NSString* const kDSSunsetTime                  = @"sunsetTime";
NSString* const kDSTemperature                 = @"temperature";
NSString* const kDSTemperatureHigh             = @"temperatureHigh";
NSString* const kDSTemperatureHighTime         = @"temperatureHighTime";
NSString* const kDSTemperatureLow              = @"temperatureLow";
NSString* const kDSTemperatureLowTime          = @"temperatureLowTime";
NSString* const kDSTemperatureMax              = @"temperatureMax";
NSString* const kDSTemperatureMin              = @"temperatureMin";
NSString* const kDSTemperatureMinTime          = @"temperatureMinTime";
NSString* const kDSTime                        = @"time";
NSString* const kDSUvIndex                     = @"uvIndex";
NSString* const kDSUvIndexTime                 = @"uvIndexTime";
NSString* const kDSVisibility                  = @"visbility";
NSString* const kDSWindBearing                 = @"windBearing";
NSString* const kDSWindGust                    = @"windGust";
NSString* const kDSWindGustTime                = @"windGustTime";
NSString* const kDSWindSpeed                   = @"windSpeed";

// Data Block Object Keys
NSString* const kDSData     = @"data";

// TODO: Icon Keys
NSString* const kDSclearDay                    = @"clear-day";
NSString* const kDSclearNight                  = @"clear-night";
NSString* const kDScloudy                      = @"cloudy";
NSString* const kDSfog                         = @"fog";
NSString* const kDShail                        = @"hail";
NSString* const kDSpartlyCloudyDay             = @"partly-cloudy-day";
NSString* const kDSpartlyCloudyNight           = @"partly-cloudy-night";
NSString* const kDSrain                        = @"rain";
NSString* const kDSsleet                       = @"sleet";
NSString* const kDSsnow                        = @"snow";
NSString* const kDSthunderstorm                = @"thunderstorm";
NSString* const kDStornado                     = @"tornado";
NSString* const kDSwind                        = @"wind";

//NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//@"value1", @"key1", @"value2", @"key2", nil];

// TODO: Alerts Object Keys

// TODO: Flags Object Keys

