//
//  JDFlipsideViewController.m
//  Serendipity
//
//  Created by Josh Deprez on 16/07/13.
//  Copyright (c) 2013 Josh Deprez. All rights reserved.
//

#import "JDFlipsideViewController.h"

@interface JDFlipsideViewController ()

@end

@implementation JDFlipsideViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

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

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
