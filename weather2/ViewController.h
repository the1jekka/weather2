//
//  ViewController.h
//  weather2
//
//  Created by Admin on 16.05.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DownPicker.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *pressureLabel;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxTemperature;
@property (strong, nonatomic) IBOutlet UILabel *minTemperature;
@property (strong, nonatomic) IBOutlet UITableView *hourForecastTableView;
@property (strong, nonatomic) IBOutlet UITableView *dailyForecastTableView;
@property (strong, nonatomic) IBOutlet UIImageView *weatherStateImageView;
@property (strong, nonatomic) IBOutlet DownPicker *cityPicker;
@end

