//
//  DatacenterPoolMore.h
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "MasterContainerVC.h"

@interface DatacenterDetailMoreVC : MasterContainerVC

@property PoolVO *poolVO;
@property DatacenterDetailPageType pageType;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;

@end
