//
//  JDFlipsideViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDFlipsideViewController;

@protocol JDFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(JDFlipsideViewController *)controller;
@end

@interface JDFlipsideViewController : UIViewController

@property (weak, nonatomic) id <JDFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
