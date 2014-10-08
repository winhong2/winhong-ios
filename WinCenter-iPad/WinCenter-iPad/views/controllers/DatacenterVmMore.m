//
//  DatacenterVmMore.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterVmMore.h"
#import "DatacenterVmCollectionVC.h"

@implementation DatacenterVmMore

-(void)refresh{
    self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
    self.titleLabel.text = [NSString stringWithFormat:@"%@下的虚拟机列表", self.poolVO.resourcePoolName];
    
    DatacenterVmCollectionVC *vc;
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterVmCollectionVC"];
    vc.poolVO = self.poolVO;
    vc.isMore = true;
    self.pages = @[vc];
    
    [super refresh];
}

@end
