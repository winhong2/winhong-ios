//
//  DatacenterBusinessMore.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterBusinessMore.h"
#import "DatacenterBusinessCollectionVC.h"
#import "MasterCollectionVC.h"

@implementation DatacenterBusinessMore

-(void)refresh{
    self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
    self.titleLabel.text = [NSString stringWithFormat:@"%@下的业务系统列表", self.poolVO.resourcePoolName];
    
    DatacenterBusinessCollectionVC *vc;
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterBusinessCollectionVC"];
    vc.isMore = true;
    self.pages = @[vc];
    
    [super refresh];
}

@end
