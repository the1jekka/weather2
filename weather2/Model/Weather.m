//
//  Weather.m
//  weather2
//
//  Created by Admin on 16.05.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import "Weather.h"
#import <OWMWeatherAPI.h>

@implementation Weather
- (void) getWeatherData
{
    //NSString *request = @"api.openweathermap.org/data/2.5/weather?q=";
    //NSString *uid = @"&APPID=d03854a47f5bacee22dc5de14d91ccda";
    //_location = @"Minsk";
    //request = [request stringByAppendingString: self.location];
    //request = [request stringByAppendingString: uid];
    NSMutableString *curTemp = [[NSMutableString alloc] init];
    OWMWeatherAPI *weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"d03854a47f5bacee22dc5de14d91ccda"];
    [weatherAPI setTemperatureFormat:kOWMTempCelcius];
    [weatherAPI currentWeatherByCityName:@"Minsk" withCallback:^(NSError *error, NSDictionary *result){
        if(error){
            return;
        }
        //NSLog(result[@"main"][@"temp"]);
        _location = result[@"name"];
       // curTemp = [NSMutableString stringWithFormat:@"%.1f",
              //            [result[@"main"][@"temp"] floatValue] ];
        _pressure = [NSMutableString stringWithFormat:@"%.1f",
                     [result[@"main"][@"pres"] floatValue]];
       
    }];
    NSLog(_temperature);
}
@end
