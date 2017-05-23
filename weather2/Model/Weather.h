//
//  Weather.h
//  weather2
//
//  Created by Admin on 16.05.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property (strong, nonatomic) NSMutableString *temperature;
@property (strong, nonatomic) NSMutableString *pressure;
@property (strong, nonatomic) NSMutableString *humidity;
@property (strong, nonatomic) NSMutableString *maxTemperaature;
@property (strong, nonatomic) NSMutableString *minTemperature;
@property (strong, nonatomic) NSMutableString *sunrise;
@property (strong, nonatomic) NSMutableString *sunset;
@property (strong, nonatomic) NSMutableString *wind;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSDictionary *data;
- (void)getWeatherData;

@end
