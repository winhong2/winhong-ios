//
//  Models.h
//  WinCenter-Common
//
//  Created by apple on 14-9-30.
//  Copyright (c) 2014年 huadi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NSObject+ObjectMap.h>
#import <Unirest/UNIRest.h>
#import <PNChart/PNChart.h>
#import <pop/POP.h>
#import <FastAnimationWithPOP/FastAnimationWithPop.h>
#import <MZFormSheetController/MZFormSheetController.h>
#define MAS_SHORTHAND
#import <Masonry/Masonry.h>
#import <CupertinoYankee/NSDate+CupertinoYankee.h>
#import <UIColor-HexString/UIColor+HexString.h>
#import <MSCollectionViewCalendarLayout/MSCollectionViewCalendarLayout.h>
#import <AMScrollingNavbar/UIViewController+ScrollingNavbar.h>
#import "UIStoryboard+Theme.h"
#import "UIButton+Badge.h"
#import "UIBarButtonItem+Badge.h"

#ifndef WinCenter_Common_Models_h
#define WinCenter_Common_Models_h

typedef NS_ENUM(NSInteger, DatacenterDetailPageType) {
    Page_Pool,
    Page_Host,
    Page_Storage,
    Page_VM,
    Page_Business
};

#import "RemoteObject.h"
#import "UserListResult.h"
#import "UserVO.h"
#import "DatacenterListResult.h"
#import "DatacenterVO.h"
#import "DatacenterStatWinserver.h"
#import "DatacenterStatVO.h"
#import "PoolListResult.h"
#import "PoolVO.h"
#import "PoolElasticInfo.h"
#import "HostListResult.h"
#import "HostVO.h"
#import "HostStatVO.h"
#import "HostNetworkListResult.h"
#import "HostNetworkVO.h"
#import "HostNicListResult.h"
#import "HostNicVO.h"
#import "StorageListResult.h"
#import "StorageVO.h"
#import "StorageVolumnListResult.h"
#import "StorageVolumnVO.h"
#import "VmListResult.h"
#import "VmVO.h"
#import "VmNetworkListResult.h"
#import "VmNetworkVO.h"
#import "VmDiskListResult.h"
#import "VmDiskVO.h"
#import "BusinessListResult.h"
#import "BusinessVO.h"
#import "BusinessVmVO.h"
#import "WarningInfoVO.h"
#import "WarningInfoListResult.h"
#import "ControlRecordVO.h"
#import "ControlRecordListResult.h"
#import "LicenseWciVO.h"
#import "LicenseVO.h"
#import "LoginVO.h"

#endif
