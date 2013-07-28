//
//  AlertViewBlockDelegate.h
//
//  Created by Josh Deprez on 16/09/10.
//  Copyright 2010-2013 Josh Deprez. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JDAlertViewBlockDelegate : NSObject <UIAlertViewDelegate> {

}

-(JDAlertViewBlockDelegate *) initWithCancelButtonAction:(void(^)())cancelButtonAction otherButtonActions:(NSArray *)otherButtonActions;
+(JDAlertViewBlockDelegate *) delegateWithCancelButtonAction:(void(^)())cancelButtonAction otherButtonActions:(void(^)())otherButtonAction, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, copy) void(^cancelButtonAction)();
@property (nonatomic, strong) NSArray *otherButtonActions;

@end
