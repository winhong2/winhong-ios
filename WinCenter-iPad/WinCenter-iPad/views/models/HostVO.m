//
//  HostVO.m
//  0805
//
//  Created by 黄茂坚 on 14-8-5.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "HostVO.h"

@implementation HostVO
- (NSString*)state_text{
    NSDictionary *stateDict = @{
                                @"OK":@"开机",
                                @"DISCONNECT":@"离线",
                                @"MAINTAIN":@"维护",
                                @"RESTART":@"重启"
                                };
    
    NSString *result = [stateDict valueForKey:self.state];
    if((result==nil) || [result isEqualToString:@""]){
        result = self.state;
    }
    return result;
}
@end
