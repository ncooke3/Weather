//
//  SettingsViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 5/9/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "SettingsViewController.h"

// Categories
#import "NSLayoutAnchor+Pinto.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSInteger units;
@property (nonatomic) NSInteger forecastColors;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load User preferences from user defaults
    _units = [[NSUserDefaults standardUserDefaults] integerForKey:@"units"];
    _forecastColors = [[NSUserDefaults standardUserDefaults] integerForKey:@"forecastColors"];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    [self configureNavigationItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    [_tableView.topAnchor pinTo:self.view.safeAreaLayoutGuide.topAnchor];
    [_tableView.leadingAnchor pinTo:self.view.safeAreaLayoutGuide.leadingAnchor];
    [_tableView.trailingAnchor pinTo:self.view.safeAreaLayoutGuide.trailingAnchor];
    [_tableView.bottomAnchor pinTo:self.view.bottomAnchor];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
}

- (void)configureNavigationItem {
    self.navigationItem.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDone)];
}

- (void)updateSettings {
    [[NSUserDefaults standardUserDefaults] setInteger:self.units forKey:@"units"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.forecastColors forKey:@"forecastColors"];
    [self.delegate settingsDidChange];
}

- (void)handleDone {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

#pragma mark - UITableViewDataSource
    
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = indexPath.row ? @"Celsius" : @"Fahrenheit";
        
        if (indexPath.row == _units) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Default";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Purple Glow";
        }
        
        if (indexPath.row == _forecastColors) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    } else if (indexPath.section == 2) {
        cell.userInteractionEnabled = NO;
        cell.tintColor = UIColor.secondaryLabelColor;
        cell.textLabel.text = indexPath.row ? @"Severe Weather Updates" : @"Rain Notifications";
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Write a Review";
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = UIColor.secondaryLabelColor;
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Share";
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = UIColor.secondaryLabelColor;
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Send Feedback";
            cell.userInteractionEnabled = NO;
            cell.textLabel.textColor = UIColor.secondaryLabelColor;
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Privacy Policy";
            cell.textLabel.textColor = UIColor.systemBlueColor;
        }
    }
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 1) {
    
        NSIndexPath *oldIndex;
        
        if (indexPath.section == 0) {
            oldIndex = [NSIndexPath indexPathForRow:_units inSection:indexPath.section];
        } else {
            oldIndex = [NSIndexPath indexPathForRow:_forecastColors inSection:indexPath.section];
        }
        
        [self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (indexPath.section == 0) {
            _units = indexPath.row;
            [self updateSettings];
        } else {
            _forecastColors = indexPath.row;
            [self updateSettings];
        }
        
    }
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            // write a review
            
            
        } else if (indexPath.row == 1) {
            // share
            
            
        } else if (indexPath.row == 2) {
            // send feedback
            NSString *subject = [NSString stringWithFormat:@"Weather App"];
            NSString *mail = [NSString stringWithFormat:@"ncooke3@gatech.edu"];
            NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                        [mail stringByAddingPercentEncodingWithAllowedCharacters:set],
                                                        [subject stringByAddingPercentEncodingWithAllowedCharacters:set]]];
            [[UIApplication sharedApplication] openURL:url options:(@{}) completionHandler:nil];
            
        } else if (indexPath.row == 3) {
            // privacy policy
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ncooke3.github.io/GazeWeather/"] options:@{} completionHandler:nil];
            
        }
        
    }

    return indexPath;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (section == 0) {
        numberOfRows = 2;
    } else if (section == 1) {
        numberOfRows = 2;
    } else if (section == 2) {
        numberOfRows = 2;
    } else if (section == 3) {
        numberOfRows = 4;
    }
    
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = [NSString new];
    if (section == 0) {
        headerTitle = @"Units";
    } else if (section == 1) {
        headerTitle = @"Forecast Colors";
    } else if (section == 2) {
        headerTitle = @"Coming Soon";
    } else if (section == 3) {
        headerTitle = @"About";
    }
    
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footerTitle = [NSString new];
    if (section == 1) {
        footerTitle = @"These themes correspond to the colors used to represent various weather conditions.";
    } else if (section == 3) {
        footerTitle = @"Weather 1.0 \nPowered by Dark Sky";
    }
    
    return footerTitle;
}

@end
