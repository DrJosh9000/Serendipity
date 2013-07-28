//
//  AlertViewBlockDelegate.m
//
//  Created by Josh Deprez on 16/09/10.
//  Copyright 2010-2013 Josh Deprez. All rights reserved.
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
