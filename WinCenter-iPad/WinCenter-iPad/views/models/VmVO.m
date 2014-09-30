//
//  vmVO.m
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-29.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "VmVO.h"

@implementation VmVO

- (NSString *) isInstallTools_text{
    return ([self.isInstallTools isEqualToString:@"true"] ? @"已安装" : @"未安装");
}
- (NSString*)osType_imageName{

    if([self.osType rangeOfString:@"window" options:NSCaseInsensitiveSearch].length>0){
        return @"os-win";
    }else if([self.osType rangeOfString:@"cent" options:NSCaseInsensitiveSearch].length>0){
        return @"os-centos";
    }else if([self.osType rangeOfString:@"suse" options:NSCaseInsensitiveSearch].length>0){
        return @"os-suse";
    }else if([self.osType rangeOfString:@"hat" options:NSCaseInsensitiveSearch].length>0){
        return @"os-redhat";
    }else{
        return @"按键";
    }
    
}

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
        @"SUSPENDED":@"挂起",
        @"UNKNOWN":@"未知",
        @"CONVERTING":@"转换中",
        @"RELOCATING":@"迁移中",
        @"BACKUPING":@"备份中",
        @"RESTORING":@"还原中",
        @"SNAPSHOT_ADDING":@"创建快照中",
        @"SNAPSHOT_DELING":@"删除快照中",
        @"SNAPSHOT_RECOVERING":@"快照还原中",
        @"RENAMEING":@"修改名称中",
        @"EXPORTING":@"导出中",
        @"UN_MOUNTING_ISO":@"弹出iso中",
        @"MOUNTING_ISO":@"挂载iso中"
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
