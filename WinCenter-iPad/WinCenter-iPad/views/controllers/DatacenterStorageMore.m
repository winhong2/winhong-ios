//
//  DatacenterStorageMore.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterStorageMore.h"
#import "DatacenterStorageCollectionVC.h"

@implementation DatacenterStorageMore

-(void)refresh{
    self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
    self.titleLabel.text = [NSString stringWithFormat:@"%@下的共享存储列表", self.poolVO.resourcePoolName];
    
    DatacenterStorageCollectionVC *vc;
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterStorageCollectionVC"];
    vc.poolVO = self.poolVO;
    vc.isMore = true;
    self.pages = @[vc];
    
    [super refresh];
}
@end
