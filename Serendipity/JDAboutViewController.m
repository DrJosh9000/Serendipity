//
//  JDAboutViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 12/08/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import "JDAboutViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface JDAboutViewController ()
@property (strong, nonatomic) CMMotionManager *motion;
@end

@implementation JDAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.motion = [CMMotionManager new];
    [self.motion startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                     withHandler:^(CMDeviceMotion *motion, NSError *error) {
                            
                                         double roll = motion.attitude.roll;
                                         //NSLog(@"Roll %f", roll);
                                         self.logoImageView.layer.transform = CATransform3DMakeRotation(-roll, 0.0, 0.0, 1.0);
    }];
}

- (IBAction)goToSourceCodePage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/jdeprez/Serendipity"]];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.motion stopDeviceMotionUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) doneButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
