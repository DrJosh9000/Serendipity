//
//  JDAboutViewController.h
//  Serendipity
//
//  Created by Josh Deprez on 12/08/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDAboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

-(IBAction) doneButtonTapped:(id)sender;
@end
