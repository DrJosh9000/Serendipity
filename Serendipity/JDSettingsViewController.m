//
//  JDSettingsViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 11/08/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import "JDSettingsViewController.h"

@interface JDSettingsViewController ()
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation JDSettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.dangerModeSwitch.on = [[self.defaults objectForKey:DANGER_MODE_KEY] boolValue];
    self.iPhoneTypeSwitch.on = [[self.defaults objectForKey:IPHONE_TYPE_KEY] boolValue];
    self.MobileTypeSwitch.on = [[self.defaults objectForKey:MOBILE_TYPE_KEY] boolValue];
    self.HomeTypeSwitch.on = [[self.defaults objectForKey:HOME_TYPE_KEY] boolValue];
    self.WorkTypeSwitch.on = [[self.defaults objectForKey:WORK_TYPE_KEY] boolValue];
    self.OtherTypeSwitch.on = [[self.defaults objectForKey:OTHER_TYPE_KEY] boolValue];
    self.MainTypeSwitch.on = [[self.defaults objectForKey:MAIN_TYPE_KEY] boolValue];
    self.FaxTypeSwitch.on = [[self.defaults objectForKey:FAX_TYPE_KEY] boolValue];
}

- (IBAction)doneButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dangerModeSwitchChanged:(id)sender {
    [self.defaults setObject:@(self.dangerModeSwitch.on) forKey:DANGER_MODE_KEY];
    [self.defaults synchronize];
}

- (IBAction)iPhoneTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.iPhoneTypeSwitch.on) forKey:IPHONE_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)mobileTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.MobileTypeSwitch.on) forKey:MOBILE_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)homeTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.HomeTypeSwitch.on) forKey:HOME_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)workTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.WorkTypeSwitch.on) forKey:WORK_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)mainTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.MainTypeSwitch.on) forKey:MAIN_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)otherTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.OtherTypeSwitch.on) forKey:OTHER_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)faxTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.FaxTypeSwitch.on) forKey:FAX_TYPE_KEY];
    [self.defaults synchronize];
}

@end
