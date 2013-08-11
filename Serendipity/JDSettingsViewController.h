//
//  JDSettingsViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 11/08/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *dangerModeSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *iPhoneTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *MobileTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *HomeTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *WorkTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *MainTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *FaxTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *OtherTypeSwitch;

- (IBAction)dangerModeSwitchChanged:(id)sender;
- (IBAction)iPhoneTypeSwitchChanged:(id)sender;
- (IBAction)mobileTypeSwitchChanged:(id)sender;
- (IBAction)homeTypeSwitchChanged:(id)sender;
- (IBAction)workTypeSwitchChanged:(id)sender;
- (IBAction)mainTypeSwitchChanged:(id)sender;
- (IBAction)otherTypeSwitchChanged:(id)sender;
- (IBAction)faxTypeSwitchChanged:(id)sender;


@end
