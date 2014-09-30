//
//  vmVO.m
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-29.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "VmVO.h"

@implementation VmVO


- (NSString*)state_text{
    NSDictionary *stateDict = @{
        @"OK":@"运行中",
        @"EXECUTING":@"部署中",
        @"CREATED":@"待部署",
        @"STARTING":@"正在启动",
        @"STOPPED":@"已关机",
        @"STOPPEING":@"关机中",
        @"DELETEING":@"删除中",
        @"RESIZEING":@"调整中",
        @"RESTARTING":@"重启中",
        @"CONVERTING":@"转换中",
        @"RESUMEING":@"恢复中",
        @"SUSPENDING":@"挂起中",
        @"SUSPENDED":@"挂起"
    };
    
    NSString *result = [stateDict valueForKey:self.state];
    if((result==nil) || [result isEqualToString:@""]){
        result = self.state;
    }
    return result;
}

- (UIColor *)state_color{
    if([self.state isEqualToString:@"OK"]){
        return [UIColor greenColor];
    }else if([self.state isEqualToString:@"STOPPED"]){
        return [UIColor lightGrayColor];
    }else{
        return [UIColor yellowColor];
    }
}
@end
