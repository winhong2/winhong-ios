//
//  LoginVO.m
//  WinCenter-iPad
//
//  Created by huadi on 14-9-17.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "LoginResult.h"

@implementation LoginResult

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"UserVO" forKeyPath:@"propertyArrayMap.users"];
    }
    return self;
}

@end
