//
//  ViewController.m
//  weather2
//
//  Created by Admin on 16.05.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import "ViewController.h"
#import <OWMWeatherAPI.h>
#import <Foundation/Foundation.h>

@interface ViewController (){
    OWMWeatherAPI *_weather;
    NSArray *_forecast;
    NSArray *_hourForecastArray;
    NSDateFormatter *_formatter;
    BOOL _hourForecast;
}
@end

@implementation ViewController

- (void)loadView{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                    70)];
    [navBar setBarTintColor:[UIColor blueColor] ];
    [navBar setTranslucent:YES];
    UIBarButtonItem *addCityButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self action:@selector(addCityButtonPressed:)];
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                target:self action:@selector(updateButtonPressed:)];
    [addCityButton setTintColor:[UIColor whiteColor]];
    [updateButton setTintColor:[UIColor whiteColor]];
    
    UITextField *temp = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 30
                                                                      , 100, 30)];
    [navBar addSubview:temp];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    NSMutableArray *result = [self arrayFromPlist];
    _cityPicker = [[DownPicker alloc] initWithTextField:temp withData:result];
    [_cityPicker addTarget:self action:@selector(dpSelected:) forControlEvents:UIControlEventValueChanged];
    [_cityPicker showArrowImage:YES];
    [_cityPicker setSelectedIndex:0];
    
    navItem.rightBarButtonItem = addCityButton;
    navItem.leftBarButtonItem = updateButton;
    navBar.items = @[navItem];
    [self.view addSubview:navBar];
    
    _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 155, 200, 50)];
    [_temperatureLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:36]];
    _pressureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 200, 200, 50)];
    _humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 150, 200, 50)];
    _maxTemperature = [[UILabel alloc] initWithFrame:CGRectMake(5, 255, 200, 50)];
    _minTemperature = [[UILabel alloc] initWithFrame:CGRectMake(5, 205, 200, 50)];
    _windLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 250, 200, 50)];
    _sunriseLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 300, 200, 50)];
    _sunsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 350, 200, 50)];
    _weatherStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 100, 200, 50)];
    _dailyForecastTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width - 20,
                                                                            self.view.frame.size.height)];
    _dailyForecastTableView.dataSource = self;
    _dailyForecastTableView.delegate = self;
    _hourForecastTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width - 20,
                                                                           self.view.frame.size.height)];
    _hourForecastTableView.dataSource = self;
    _hourForecastTableView.delegate = self;
    _weatherStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 100, 50, 50)];
    [self getWeatherData:[_cityPicker text]];
    _temperatureLabel.textColor = [UIColor blackColor];
    _pressureLabel.textColor = [UIColor blackColor];
    _humidityLabel.textColor = [UIColor blackColor];
    _weatherStateLabel.textColor = [UIColor blackColor];
    _windLabel.textColor = [UIColor blackColor];
    [_dailyForecastTableView setHidden:YES];
    [_hourForecastTableView setHidden:YES];
    [self.view addSubview:_temperatureLabel];
    [self.view addSubview:_humidityLabel];
    [self.view addSubview:_pressureLabel];
    [self.view addSubview:_weatherStateLabel];
    [self.view addSubview:_windLabel];
    [self.view addSubview:_sunriseLabel];
    [self.view addSubview:_sunsetLabel];
    [self.view addSubview:_minTemperature];
    [self.view addSubview:_maxTemperature];
    [self.view addSubview:_dailyForecastTableView];
    [self.view addSubview:_hourForecastTableView];
    [self.view addSubview:_weatherStateImageView];
    UIButton *weatherButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [weatherButton setTitle:@"Current" forState:UIControlStateNormal];
    [weatherButton sizeToFit];
    weatherButton.center = CGPointMake(30, 80);
    [weatherButton addTarget:self action:@selector(weatherButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weatherButton];
    UIButton *forecastButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forecastButton setTitle:@"Forecast" forState:UIControlStateNormal];
    [forecastButton sizeToFit];
    forecastButton.center = CGPointMake(self.view.frame.size.width / 2, 80);
    [forecastButton addTarget:self action:@selector(forecastButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forecastButton];
    UIButton *hourForecastButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hourForecastButton setTitle:@"Hour" forState:UIControlStateNormal];
    [hourForecastButton sizeToFit];
    hourForecastButton.center = CGPointMake(self.view.frame.size.width - 30, 80);
    [hourForecastButton addTarget:self action:@selector(hourForecastButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hourForecastButton];
    
    
    
    
}

- (void)getWeatherData:(NSString *)cityName{
    _weather = [[OWMWeatherAPI alloc] initWithAPIKey:@"d03854a47f5bacee22dc5de14d91ccda"];
    [_weather setTemperatureFormat:kOWMTempCelcius];
    [_weather currentWeatherByCityName:cityName withCallback:^(NSError *error, NSDictionary *result){
        if(error){
            return ;
        }
        _temperatureLabel.text = [NSString stringWithFormat:@"%.1f℃",
                                 [result[@"main"][@"temp"] floatValue]];
        _minTemperature.text = [NSString stringWithFormat:@"%@: %.1f℃",@"Min",
                                  [result[@"main"][@"temp_min"] floatValue]];
        _maxTemperature.text = [NSString stringWithFormat:@"%@: %.1f℃", @"Max",
                                  [result[@"main"][@"temp_max"] floatValue]];
        _pressureLabel.text = [NSString stringWithFormat:@"%@: %.1f %@", @"Pressure",
                               [result[@"main"][@"pressure"] floatValue] * 100 / 133.322, @"mm Hg"];
        _humidityLabel.text = [NSString stringWithFormat:@"%@: %.1f%@",@"Humidity",
                               [result[@"main"][@"humidity"] floatValue], @"%"];
        _weatherStateLabel.text = result[@"weather"][0][@"description"];
        _windLabel.text = [NSString stringWithFormat:@"%@: %.1f %@",
                           @"Wind", [result[@"wind"][@"speed"] floatValue], @" km/h"];
        
        NSString *imageURL = [NSString stringWithFormat:@"%@%@%@", @"http://openweathermap.org/img/w/",
                              result[@"weather"][0][@"icon"], @".png"];
        NSLog(@"%@", imageURL);
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSLog(@"%@", data);
            _weatherStateImageView.image = [UIImage imageWithData:data];
            _weatherStateImageView.contentMode = UIViewContentModeCenter;
        }];
        
        NSString *dateComponents = @"H:m";
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:[NSLocale systemLocale]];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:dateFormat];

        _sunriseLabel.text = [NSString stringWithFormat:@"%@: %@", @"Sunrise", [_formatter stringFromDate:
                                                                                result[@"sys"][@"sunrise"]]];
        _sunsetLabel.text = [NSString stringWithFormat:@"%@: %@", @"Sunset", [_formatter stringFromDate:
                                                                                result[@"sys"][@"sunset"]]];
        [imageURL release];
        [dateComponents release];
        [dateFormat release];
        [_formatter release];
    }];
    [_weather dailyForecastWeatherByCityName:cityName withCount:7 andCallback:^(NSError *error, NSDictionary *result){
        if(error){
            return ;
        }
        _hourForecast = NO;
        _forecast = [[NSArray alloc] initWithArray:result[@"list"]];
        [_dailyForecastTableView reloadData];
    }];
    [_weather forecastWeatherByCityName:cityName withCallback: ^(NSError *error, NSDictionary *result){
        if(error){
            return ;
        }
        _hourForecast = YES;
        _hourForecastArray = [[NSArray alloc] initWithArray: result[@"list"]];
        [_hourForecastTableView reloadData];
    }];
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_forecast count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    if(!_hourForecast){
        NSString *dateComponents = @"dMMMM";
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:[NSLocale systemLocale]];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:dateFormat];

        NSDictionary *forecastData = [[NSDictionary alloc] initWithDictionary: [_forecast objectAtIndex:indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%.1f℃ / %.1f℃",
                               [forecastData[@"temp"][@"min"] floatValue],
                               [forecastData[@"temp"][@"max"] floatValue]];
    
        cell.detailTextLabel.text = [_formatter stringFromDate:forecastData[@"dt"]];
        [dateComponents release];
        [dateFormat release];
        [_formatter release];
        [forecastData release];
    }
    else{
        NSString *dateComponents = @"H:m";
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:[NSLocale systemLocale]];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:dateFormat];

        NSDictionary* forecastData = [[NSDictionary alloc] initWithDictionary:
                                      [_hourForecastArray objectAtIndex:indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%.1f℃ - %@",
                               [forecastData[@"main"][@"temp"] floatValue],
                               forecastData[@"weather"][0][@"main"]];
        
        cell.detailTextLabel.text = [_formatter stringFromDate:forecastData[@"dt"]];
        [dateComponents release];
        [dateFormat release];
        [_formatter release];
        [forecastData release];
    }
    return cell;
    
}

-(IBAction)updateButtonPressed:(UIBarButtonItem*)sender{
    [self getWeatherData:[_cityPicker text]];
}


- (IBAction)weatherButtonPressed:(UIButton*)sender{
    [_temperatureLabel setHidden:NO];
    [_pressureLabel setHidden:NO];
    [_pressureLabel setHidden:NO];
    [_weatherStateLabel setHidden:NO];
    [_windLabel setHidden:NO];
    [_maxTemperature setHidden:NO];
    [_minTemperature setHidden:NO];
    [_sunsetLabel setHidden:NO];
    [_sunriseLabel setHidden:NO];
    [_weatherStateImageView setHidden:NO];
    [_dailyForecastTableView setHidden:YES];
    [_hourForecastTableView setHidden:YES];
    
}

- (IBAction)forecastButtonPressed:(UIButton *)sender{
    [_temperatureLabel setHidden:YES];
    [_pressureLabel setHidden:YES];
    [_pressureLabel setHidden:YES];
    [_weatherStateLabel setHidden:YES];
    [_windLabel setHidden:YES];
    [_maxTemperature setHidden:YES];
    [_minTemperature setHidden:YES];
    [_sunsetLabel setHidden:YES];
    [_sunriseLabel setHidden:YES];
    [_weatherStateImageView setHidden:YES];
    [_dailyForecastTableView setHidden:NO];
    [_hourForecastTableView setHidden:YES];
}

- (IBAction)hourForecastButtonPressed:(UIButton *)sender{
    [_temperatureLabel setHidden:YES];
    [_pressureLabel setHidden:YES];
    [_pressureLabel setHidden:YES];
    [_weatherStateLabel setHidden:YES];
    [_windLabel setHidden:YES];
    [_maxTemperature setHidden:YES];
    [_minTemperature setHidden:YES];
    [_sunsetLabel setHidden:YES];
    [_sunriseLabel setHidden:YES];
    [_weatherStateImageView setHidden:YES];
    [_dailyForecastTableView setHidden:YES];
    [_hourForecastTableView setHidden:NO];
}

-(void)addCityButtonPressed:(UIBarButtonItem *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add city" message:@"Enter city name"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"";
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   UITextField *tempField = alert.textFields.firstObject;
                                                   NSString *input = tempField.text;
                                                   NSMutableArray *temp = [self arrayFromPlist];
                                                   [temp addObject:input];
                                                   [self writeArrayToPlist:temp];
                                                   [_cityPicker setData:temp];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    [alert release];
    
}

- (NSMutableArray*)arrayFromPlist {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    NSString *filePath = [documentFolder stringByAppendingFormat:@"citiesList.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        filePath = [documentFolder stringByAppendingPathComponent: [NSString stringWithFormat:@"citiesList.plist"]];
        NSArray *defaultCities = [NSArray arrayWithObjects:@"Minsk", @"Moscow", nil];
        [defaultCities writeToFile:filePath atomically:YES];
    }
    NSMutableArray* propertyListValues = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    [fileManager release];
    return [propertyListValues autorelease];
}

- (void)writeArrayToPlist:(NSArray*)plistArr{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    NSString *filePath = [documentFolder stringByAppendingFormat:@"citiesList.plist"];
    [plistArr writeToFile:filePath atomically:YES];
}

-(void)dpSelected:(id)dp{
    NSString *selectedValue = [_cityPicker text];
    [self getWeatherData:selectedValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
