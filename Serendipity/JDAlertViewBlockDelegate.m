//
//  AlertViewBlockDelegate.m
//
//  Created by Josh Deprez on 16/09/10.
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

#import "JDAlertViewBlockDelegate.h"


@implementation JDAlertViewBlockDelegate

@synthesize cancelButtonAction, otherButtonActions;

-(JDAlertViewBlockDelegate *) initWithCancelButtonAction:(void(^)())cancel otherButtonActions:(NSArray *)other
{
	if (self = [super init])
	{
		self.cancelButtonAction = cancel; // copy
		self.otherButtonActions = other; // hope that the user called copy on all of them / using ARC
	}
	return self;
}


+(JDAlertViewBlockDelegate *) delegateWithCancelButtonAction:(void(^)())cancel otherButtonActions:(void(^)())other, ...
{
	NSMutableArray *m = [NSMutableArray array];
	va_list args;
	va_start(args, other);
	void (^arg)();
	for (arg = other; arg != nil; arg = va_arg(args, void(^)()))
	{
		[m addObject:[arg copy]];
	}
	va_end(args);
	
	return [[JDAlertViewBlockDelegate alloc] initWithCancelButtonAction:cancel otherButtonActions:m];
}

/*
-(void)dealloc
{
	self.cancelButtonAction = nil;
	self.otherButtonActions = nil;
	//[super dealloc];
}
 */


#pragma mark -
#pragma mark UIAlertView delegate

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex)
	{
		if (self.cancelButtonAction) self.cancelButtonAction();
	}
	else {
		NSUInteger index = buttonIndex - alertView.firstOtherButtonIndex;
		void (^action)() = [self.otherButtonActions objectAtIndex:index];
		if (action) action();
	}
}

@end
