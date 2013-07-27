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
    
    CFErrorRef err = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    NSString *name;
    
    int randomContact = rand() % nPeople;

    ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, randomContact );
    
    //ABRecordID ident = ABRecordGetRecordID(ref);
    //NSLog(@"%d", ident);
    
    //ABRecordType type = ABRecordGetRecordType(ref);
    //NSLog(@"%@", (type==kABPersonType ? @"Person" : (type==kABGroupType ? @"Group" : @"Source")));
    
    name = (__bridge NSString *)(ABRecordCopyCompositeName(ref));
    //NSLog(@"%@", name);
    
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Now calling %@", name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:130-032-2837"]]];
    } else {
//        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature. (You'll have to make the phone call yourself...)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [Notpermitted show];
    }
    
}
@end
