//
//  JDMainViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import "JDFlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface JDMainViewController : UIViewController <JDFlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)doRandomCall:(id)sender;

@end
