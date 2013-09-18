//
//  JDMainViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
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
#import "JDMainViewController.h"
#import "JDAlertViewBlockDelegate.h"
#import "AddressBook/AddressBook.h"

@interface JDSimpleContactDetails : NSObject
@property (nonatomic, strong) NSString *name, *label, *phone;
+(JDSimpleContactDetails *) newWithName:(NSString *)name label:(NSString *)label phone:(NSString*)phone;
@end
@implementation JDSimpleContactDetails
+(JDSimpleContactDetails *) newWithName:(NSString *)name label:(NSString *)label phone:(NSString*)phone
{
    JDSimpleContactDetails *inst = [[JDSimpleContactDetails alloc] init];
    inst.name=name;
    inst.label=label;
    inst.phone=phone;
    return inst;
}
-(NSString *) description {
    return [NSString stringWithFormat:@"{ name: \"%@\", label: \"%@\", phone: \"%@\" }", self.name, self.label, self.phone];
}
@end

@interface JDMainViewController ()
@property (nonatomic, strong) JDAlertViewBlockDelegate *confirmAlertDelegate;
@property (nonatomic, strong) NSMutableArray *candidateList;
@property (nonatomic, strong) NSTimer *buttonAnimationTimer;
-(void) reassureTheUser;
@end

@implementation JDMainViewController

-(void) reassureTheUser {
    [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                message:@"In order to suggest random phone calls, I need access to your Contacts. Go to Settings and change that. Don't worry, I will never secretly send your contacts to the NSA (or anyone else)."
                               delegate:nil
                      cancelButtonTitle:@"No worries, buddy."
                      otherButtonTitles:nil] show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.dangerModeWarning.alpha = [[defaults objectForKey:DANGER_MODE_KEY] boolValue] ? 1.0 : 0.0;

    self.buttonAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                                 target:self
                                                               selector:@selector(doButtonRotation:)
                                                               userInfo:nil
                                                                repeats:YES];
}


-(void) doButtonRotation:(NSTimer *)theTimer
{
    NSTimeInterval secs = [NSDate timeIntervalSinceReferenceDate];
    const CGFloat radsperdeg = 0.0174532925;
    //NSLog(@"%f", fmod(secs, 360)*0.0174532925);
    self.randomCallButton.layer.transform = CATransform3DMakeRotation(fmod(secs * 2.0, 360.0)*radsperdeg,0.0,0.0,1.0);
    [self.randomCallButton.layer setNeedsDisplay];
    self.settingsButton.layer.transform = CATransform3DMakeRotation(-fmod(secs * 5.0, 360.0)*radsperdeg,0.0,0.0,1.0);
    [self.settingsButton.layer setNeedsDisplay];
}



/// Assumes address book is accessible.
-(void) createCandidateList {
    
    // Prepare a list of people who could be called.
    self.candidateList = [NSMutableArray arrayWithCapacity:100];
    
    CFErrorRef err = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    if (nPeople > 0) {
        
        NSDictionary *typeLookup = @{
                                     (__bridge NSString*)kABPersonPhoneIPhoneLabel: IPHONE_TYPE_KEY,
                                     (__bridge NSString*)kABPersonPhoneMainLabel: MAIN_TYPE_KEY,
                                     (__bridge NSString*)kABPersonPhoneMobileLabel: MOBILE_TYPE_KEY,
                                     (__bridge NSString*)kABHomeLabel: HOME_TYPE_KEY,
                                     (__bridge NSString*)kABWorkLabel: WORK_TYPE_KEY,
                                     (__bridge NSString*)kABOtherLabel: OTHER_TYPE_KEY,
                                     (__bridge NSString*)kABPersonPhoneHomeFAXLabel: HOME_FAX_TYPE_KEY,
                                     (__bridge NSString*)kABPersonPhoneWorkFAXLabel: WORK_FAX_TYPE_KEY,
                                     (__bridge NSString*)kABPersonPhoneOtherFAXLabel: OTHER_FAX_TYPE_KEY,
                                     (__bridge NSString*)kABPersonPhonePagerLabel: PAGER_TYPE_KEY
                                     };
        NSDictionary *niceLabelLookup = @{
                                          (__bridge NSString*)kABPersonPhoneIPhoneLabel: @"iPhone",
                                          (__bridge NSString*)kABPersonPhoneMainLabel: @"main line",
                                          (__bridge NSString*)kABPersonPhoneMobileLabel: @"mobile",
                                          (__bridge NSString*)kABHomeLabel: @"home",
                                          (__bridge NSString*)kABWorkLabel: @"work",
                                          (__bridge NSString*)kABOtherLabel: @"other line",
                                          (__bridge NSString*)kABPersonPhoneHomeFAXLabel: @"home FAX",
                                          (__bridge NSString*)kABPersonPhoneWorkFAXLabel: @"work FAX",
                                          (__bridge NSString*)kABPersonPhoneOtherFAXLabel: @"other FAX",
                                          (__bridge NSString*)kABPersonPhonePagerLabel: @"pager"
                                          };
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
        
        // Get list of blocked IDs
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"BlockedContact" inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        fetch.entity = ent;
        
        NSError *err;
        NSArray *blocked = [self.managedObjectContext executeFetchRequest:fetch error:&err];
        if (blocked == nil)
        {
            // TODO: throw error I guess?
            return;
        }
        
        for (int i=0; i<nPeople; ++i)
        {
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
            
            // Reject blocked contacts by ID
            ABRecordID ident = ABRecordGetRecordID(ref);
            if ([blocked containsObject:@(ident)]) {
                continue;
            }
            
            // Get name
            NSString *name = (__bridge_transfer NSString *)(ABRecordCopyCompositeName(ref));
            
            // Get the phone numbers
            ABMultiValueRef phoneMV = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            int phoneCount = ABMultiValueGetCount(phoneMV);
            
            for (int j=0; j<phoneCount; ++j)
            {
                NSString *label = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(phoneMV, j);
                if (label != nil) {
                    NSString *typeKey = [typeLookup objectForKey:label];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if ([[defaults valueForKey:typeKey] boolValue])
                    {
                        NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneMV, j);
                        NSString *niceLabel = [niceLabelLookup objectForKey:label];
                        
                        // Finally, add a record to the array of choices
                        [self.candidateList addObject:
                         [JDSimpleContactDetails newWithName:name
                                                       label:niceLabel
                                                       phone:phone]];
                        
                    }
                }
            }
            CFRelease(phoneMV);
        }
        CFRelease(allPeople);
    }
    //NSLog(@"%@", self.candidateList);
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // On each appearance, check which contacts are available considering the options chosen.
    // This in turn requires address book access.
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
        
        [self createCandidateList];
        
    } else {
        
        CFErrorRef err = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            if (!granted) {
                [self reassureTheUser];
            } else {
                [self createCandidateList];
            }
        });
        CFRelease(addressBook);

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(id)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
     */
    [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
}

- (IBAction)doRandomCall:(id)sender {
    
    // Check device capability
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        
        // Check candidate list
        if (self.candidateList.count > 0) {
            
            // Make a random selection!
            uint idx = random() % self.candidateList.count;
            JDSimpleContactDetails *record = [self.candidateList objectAtIndex:idx];
            NSString *escapedPhone = [record.phone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([[defaults valueForKey:DANGER_MODE_KEY] boolValue])
            {
                // No confirmation!
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",escapedPhone]]];
                
            } else {
            
                // Do alert confirmation.
                UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                                  message:[NSString stringWithFormat:@"Call %@'s %@ (%@)?", record.name, record.label, record.phone]
                                                                 delegate:nil
                                                        cancelButtonTitle:@"No"
                                                        otherButtonTitles:@"Yes", nil];
                
                self.confirmAlertDelegate = [JDAlertViewBlockDelegate delegateWithCancelButtonAction:
                                    ^{
                                        // NOPE.JPG
                                        //NSLog(@"Nope, not calling %@ %@", name, phone);
                                        self.confirmAlertDelegate = nil;
                                    }
                                                                         otherButtonActions:
                                    ^{
                                        //NSLog(@"Calling %@ %@", name, phone);
                                        
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",escapedPhone]]];
                                        self.confirmAlertDelegate = nil;
                                    }, nil];
                confirm.delegate = self.confirmAlertDelegate;
                [confirm show];
            }
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                        message:@"I couldn't find a phone for you to call, probably because you've set the options all weird. Please check the settings."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
            
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                    message:[NSString stringWithFormat:@"Your %@ doesn't support this feature. (You'll have to make the phone call yourself...)", device.model]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
@end
