//
//  PoolVO.h
//  0805
//
//  Created by 黄茂坚 on 14-8-5.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoolVO : BaseObject

@property int resourcePoolId;
@property NSString *resourcePoolName;
@property int hostNumber;
@property int vmNumber;
@property int activeVmNumber;
@property float totalLogicalCpu;

@property float totalCpu;
@property float totalMemory;
@property float totalStorage;
@property float availCpu;
@property float availMemory;
@property float availStorage;
@property NSString *haEnabled;

@end
