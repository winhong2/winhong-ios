//
//  vmVO.h
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-29.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VmVO : BaseObject


@property NSString *isInstallTools;
@property int runTime;

@property BOOL isDynamicCpu;
@property BOOL isDynamicMemWce;
@property NSString *memoryType;

@property int vmId;
@property NSString *name;
@property NSString *ip;
@property NSString *state;
@property int vcpu;
@property int memory;
@property int storage;
@property NSString *osType;
@property int poolId;
@property NSString *poolName;
@property int ownerHostId;
@property NSString *ownerHostName;

- (NSString*)state_text;

@end
