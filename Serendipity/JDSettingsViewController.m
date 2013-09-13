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
    self.HomeFaxTypeSwitch.on = [[self.defaults objectForKey:HOME_FAX_TYPE_KEY] boolValue];
    self.WorkFaxTypeSwitch.on = [[self.defaults objectForKey:WORK_FAX_TYPE_KEY] boolValue];
    self.OtherFaxTypeSwitch.on = [[self.defaults objectForKey:OTHER_FAX_TYPE_KEY] boolValue];
    self.PagerTypeSwitch.on = [[self.defaults objectForKey:PAGER_TYPE_KEY] boolValue];
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

- (IBAction)homeFaxTypeSwitchChanged:(id)sender {
    
    [self.defaults setObject:@(self.HomeFaxTypeSwitch.on) forKey:HOME_FAX_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)pagerTypeSwitchChanged:(id)sender {
    [self.defaults setObject:@(self.PagerTypeSwitch.on) forKey:PAGER_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)workFaxTypeSwitchChanged:(id)sender {
    [self.defaults setObject:@(self.WorkFaxTypeSwitch.on) forKey:WORK_FAX_TYPE_KEY];
    [self.defaults synchronize];
}

- (IBAction)otherFaxTypeSwitchChanged:(id)sender {
    [self.defaults setObject:@(self.OtherFaxTypeSwitch.on) forKey:OTHER_FAX_TYPE_KEY];
    [self.defaults synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
}

@end
