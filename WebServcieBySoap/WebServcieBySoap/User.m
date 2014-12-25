//
//  User.m
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <objc/runtime.h>
#import "User.h"
#import "NSString+XMLExtensions.h"

@implementation User
@synthesize userID = _userID;
@synthesize userName = _userName;

- (id) init {
    if(self = [super init]) {
        
    }
    return self;
}

-(void)dealloc {
	self.userID = nil;
    self.userName = nil;
    [super dealloc];
}

@end
