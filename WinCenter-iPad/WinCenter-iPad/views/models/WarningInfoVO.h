//
//  WaringInfoVO.h
//  WinCenter-iPad
//
//  Created by 黄茂坚 on 14-9-29.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarningInfoVO : NSObject

@property int warningId;
@property int warningUuid;
@property NSString *objectId;
@property NSString *objectName;
@property NSString *objectType;
@property NSString *objectUuid;
@property NSString *objectSource;
@property NSString *name;
@property NSString *type;
@property NSString *body;
@property NSString *createTime;
@property NSString *priority;
@property NSString *address;
@property NSString *readed;
@property NSString *poolOriginalId;
@property NSString *uri;

@end
//{
//    "warningId": 22,
//    "warningUuid": null,
//    "objectId": "30",
//    "objectName": "勿动-CNware53版本交付产物",
//    "objectType": "VM",
//    "objectUuid": "4da3ea7d-a9fd-3979-2d3a-32538e370d27",
//    "objectSource": "network",
//    "name": "网络使用速率警报 ",
//    "type": "1",
//    "body": "服务器勿动-CNware53版本交付产物上的网络使用速率达到2.47Kbps,</br>该警报设置为在网络使用速率超过1.00Kbps时触发",
//    "createTime": "2014-09-29 13:36:19",
//    "priority": "1",
//    "address": "",
//    "readed": "false",
//    "poolOriginalId": null,
//    "uri": null
//}