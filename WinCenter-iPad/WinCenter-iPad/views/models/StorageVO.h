//
//  storageVO.h
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-28.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageVO : BaseObject

@property int resourcePoolId;
@property NSString *resourcePoolName;

@property int hostId;
@property NSString *hostName;

@property int storagePoolId;
@property NSString *storagePoolName;
@property float totalStorage;
@property float availStorage;
@property float allocatedStorage;
@property int volumeNum;
@property int hostNum;
@property int vmNum;
@property NSString *state;
@property NSString *shared;
@property NSString *defaulted;
@property NSString *type;
@property NSString *location;


-(NSString *)state_text;
-(NSString *)shared_text;

-(float)usedRatio;

-(UIColor *)usedRatioColor;

-(float)allocatedRatio;

-(UIColor *)allocatedRatioColor;

@end
