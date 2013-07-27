//
//  JDAppDelegate.h
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
