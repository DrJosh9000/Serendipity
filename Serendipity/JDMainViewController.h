//
//  JDMainViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JDMainViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIImageView *dangerModeWarning;
@property (weak, nonatomic) IBOutlet UIButton *randomCallButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

- (IBAction)doRandomCall:(id)sender;

@end
