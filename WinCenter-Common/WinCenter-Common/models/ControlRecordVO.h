//
//  ControlRecordVO.h
//  WinCenter-iPad
//
//  Created by 黄茂坚 on 14-9-29.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlRecordVO : NSObject

@property NSString *taskName;
@property int executeTime;
@property NSString *endTime;
@property int progress;
@property NSString *state;
@property NSString *user;
@property NSString *targetName;
@property int resPoolId;
@property int hostId;
@property int vmId;



@end
//"tasks": [
//          {
//              "taskName": "收集存储池",//名称
//              "executeTime": 1407738165000,//开始时间
//              "endTime": 1407738171000,//结束时间
//              "progress": 100,//进度
//              "state": "completedAndError",//状态
//              "user": "admin",//操作用户
//              "targetName": "168nfs",//目标名称
//              "resPoolId": 1,
//              "hostId": null,
//              "vmId": null,
//          }]