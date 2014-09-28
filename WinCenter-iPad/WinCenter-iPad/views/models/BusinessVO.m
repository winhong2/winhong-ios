//
//  BusinessVO.m
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-28.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "BusinessVO.h"

@implementation BusinessVO
-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"BusinessVmVO" forKeyPath:@"propertyArrayMap.wceBusVms"];
    }
    return self;
}
@end
