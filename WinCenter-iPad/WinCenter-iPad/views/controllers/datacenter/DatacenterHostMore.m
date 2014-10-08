//
//  DatacenterHostMore.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterHostMore.h"
#import "DatacenterHostCollectionVC.h"

@implementation DatacenterHostMore

-(void)refresh{
    self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
    self.titleLabel.text = [NSString stringWithFormat:@"%@下的物理机列表", self.poolVO.resourcePoolName];
    
    DatacenterHostCollectionVC *vc;
    
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterHostCollectionVC"];
    vc.poolVO = self.poolVO;
    vc.isMore = true;
    self.pages = @[vc];
    
    [super refresh];
}
@end
