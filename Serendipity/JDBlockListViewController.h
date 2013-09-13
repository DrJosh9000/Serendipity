//
//  JDBlockListViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 12/08/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface JDBlockListViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction) doneButtonTapped:(id)sender;
-(IBAction) addButtonTapped:(id)sender;

@end
