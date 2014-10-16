//
//  PoolCollectionVC.h
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "MasterCollectionVC.h"
#import "F3BarGauge.h"

@interface DatacenterDetailCollectionVC : MasterCollectionVC

@property BOOL isMore;
@property BOOL isDetailPagePushed;
@property PoolVO *poolVO;
@property DatacenterDetailPageType pageType;
@property UIPopoverController *popover;


@end
