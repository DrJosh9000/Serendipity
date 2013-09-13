//
//  JDAboutViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 12/08/13.
//
//  Serendipity is licensed under the MIT license.
//
//  Copyright (c) 2012 Josh Deprez.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
