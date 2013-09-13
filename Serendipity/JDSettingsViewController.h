//
//  JDSettingsViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 11/08/13.
//
//  Serendipity is licensed under the MIT license.
//
//  Copyright (c) 2012 Josh Deprez.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
#import <UIKit/UIKit.h>

@interface JDSettingsViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UISwitch *dangerModeSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *iPhoneTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *MobileTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *HomeTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *WorkTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *MainTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *HomeFaxTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *WorkFaxTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *OtherFaxTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *OtherTypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *PagerTypeSwitch;

- (IBAction)dangerModeSwitchChanged:(id)sender;
- (IBAction)iPhoneTypeSwitchChanged:(id)sender;
- (IBAction)mobileTypeSwitchChanged:(id)sender;
- (IBAction)homeTypeSwitchChanged:(id)sender;
- (IBAction)workTypeSwitchChanged:(id)sender;
- (IBAction)mainTypeSwitchChanged:(id)sender;
- (IBAction)otherTypeSwitchChanged:(id)sender;
- (IBAction)homeFaxTypeSwitchChanged:(id)sender;
- (IBAction)pagerTypeSwitchChanged:(id)sender;
- (IBAction)workFaxTypeSwitchChanged:(id)sender;
- (IBAction)otherFaxTypeSwitchChanged:(id)sender;


@end
