//
//  JDMainViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import "JDMainViewController.h"
#import "AddressBook/AddressBook.h"

@interface JDMainViewController ()

@end

@implementation JDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CFErrorRef err = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        if (!granted) {
            [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"In order to suggest random phone calls, I need access to your Contacts. Go to Settings and change that. Don't worry, I will never secretly send your contacts to the NSA (or anyone else)." delegate:nil cancelButtonTitle:@"No worries, buddy." otherButtonTitles:nil] show];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(JDFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)doRandomCall:(id)sender {
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {


    //UIDevice *device = [UIDevice currentDevice];
    //if ([[device model] isEqualToString:@"iPhone"]) {
        CFErrorRef err = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);

        CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
        
        if (nPeople > 0) {
            
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
            int randomIndex = rand() % nPeople;

            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, randomIndex);
            
            //ABRecordID ident = ABRecordGetRecordID(ref);
            //NSLog(@"%d", ident);
            
            //ABRecordType type = ABRecordGetRecordType(ref);
            //NSLog(@"%@", (type==kABPersonType ? @"Person" : (type==kABGroupType ? @"Group" : @"Source")));
            
            NSString *name = (__bridge NSString *)(ABRecordCopyCompositeName(ref));
            //NSLog(@"%@", name);
            
            // Get the phone numbers
            
            ABMultiValueRef phoneMV = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            NSArray* phones = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(phoneMV);
            
            if (phones.count > 0) {
                
                id phone = [phones objectAtIndex: rand() % phones.count];
                
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Now calling %@ (%@)", name, phone] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]]];
                
            }
            


        } else {
            [[[UIAlertView alloc] initWithTitle:@"No contacts on phone" message:@"You seem to have no contacts at all! Would you like to dial a completely random phone number?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
        }
    //} else {
    //    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your device doesn't support this feature. (You'll have to make the phone call yourself...)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //}
    
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"In order to suggest random phone calls, I need access to your Contacts. Go to Settings and change that. Don't worry, I will never secretly send your contacts to the NSA (or anyone else)." delegate:nil cancelButtonTitle:@"No worries, buddy." otherButtonTitles:nil] show];
    }
}
@end
