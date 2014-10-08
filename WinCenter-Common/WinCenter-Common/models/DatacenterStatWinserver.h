//
//  DatacenterStatWinserver.h
//  WinCenter-iPad
//
//  Created by huadi on 14-9-26.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatacenterStatWinserver : NSObject

@property int resPoolNumber;//from json
@property int hostNubmer;//from json
@property int vmNumber;//from json
@property int physicalCpuNumber;//from json
@property float memorySize;//from json
@property float storageSize;//from json
@property int appNumber;

@end
