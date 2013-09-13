//
//  JDBlockListViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 12/08/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import "JDBlockListViewController.h"

@interface JDBlockListViewController ()
@property (strong, nonatomic) NSFetchedResultsController *frc;
@property (strong, nonatomic) NSEntityDescription *blockedContactEntity;
@property (strong, nonatomic) __attribute__((NSObject)) ABAddressBookRef addressBook;
@end

@implementation JDBlockListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Obtain the address book
    CFErrorRef err1 = NULL;
    self.addressBook = ABAddressBookCreateWithOptions(NULL, &err1);
    
    // Get list of blocked IDs
    self.blockedContactEntity = [NSEntityDescription entityForName:@"BlockedContact" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = self.blockedContactEntity;
    fetch.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"addressBookID" ascending:YES] ];
    
    self.frc = [[NSFetchedResultsController alloc]
                        initWithFetchRequest:fetch
                        managedObjectContext:self.managedObjectContext
                          sectionNameKeyPath:nil
                                   cacheName:nil];
    self.frc.delegate = self;
    NSError *err = nil;
    [self.frc performFetch:&err];
    if (err != nil) {
        // TODO: something with error
        
    }
    
    // In case the user deletes a contact while in background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

// When the view reappears, ensure there are no stale contacts
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //NSLog(@"Got viewDidAppear");
    [self removeMissingContacts];

}

-(void) appDidBecomeActiveNotification:(NSNotification *) note
{
   // NSLog(@"Got appDidBecomeActiveNotification");
    [self removeMissingContacts];
}

-(void) removeMissingContacts
{
    // Must get a new Address Book ?
    CFErrorRef err1 = NULL;
    self.addressBook = ABAddressBookCreateWithOptions(NULL, &err1);
    
    BOOL changed = NO;
    for (NSManagedObject* record in [self.frc fetchedObjects])
    {
        ABRecordRef ref = ABAddressBookGetPersonWithRecordID(self.addressBook, [[record valueForKey:@"addressBookID"] intValue]);
        if (ref == NULL) {
            [self.managedObjectContext deleteObject: record];
            changed = YES;
        }
        /*else
        {
            NSLog(@"%@", (__bridge_transfer NSString *)ABRecordCopyCompositeName(ref));
        }*/
    }
    if (changed) {
        NSError *err;
        [self.managedObjectContext save:&err];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addButtonTapped:(id)sender
{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    //peoplePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    peoplePicker.navigationBar.tintColor = [UIColor redColor];
    [self.navigationController presentViewController:peoplePicker animated:YES completion:NULL];
    
}

-(void)doneButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - People picker delegate

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    int recordID = ABRecordGetRecordID(person);
    
    BOOL unique = YES;
    for (NSManagedObject *existing in self.frc.fetchedObjects)
    {
        if ([[existing valueForKey:@"addressBookID"] intValue] == recordID)
        {
            unique = NO;
            break;
        }
    }
    
    if (unique) {
        NSManagedObject *record = [[NSManagedObject alloc]
                                   initWithEntity:self.blockedContactEntity
                                   insertIntoManagedObjectContext:self.managedObjectContext];
        [record setValue: @(recordID) forKey:@"addressBookID"];
        NSError *err = nil;
        [self.managedObjectContext save:&err];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

#pragma mark - Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *blockedContact = [self.frc objectAtIndexPath:indexPath];
    int recordID = [[blockedContact valueForKey:@"addressBookID"] intValue];
    
    // Get AB record
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(self.addressBook, recordID);
    
    // Get name
    NSString *name = (__bridge_transfer NSString *)(ABRecordCopyCompositeName(record));
    
    cell.textLabel.text = name;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.managedObjectContext deleteObject:
         [self.frc objectAtIndexPath:indexPath]];
        NSError *err =nil;
        [self.managedObjectContext save:&err];
        // FRC delegate gets fired to remove the row
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
