//
//  PoolContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PoolContainerVC.h"
#import "PoolDetailInfoVC.h"
#import "PoolHostCollectionVC.h"
#import "PoolVmCollectionVC.h"
#import "PoolStorageCollectionVC.h"

@implementation PoolContainerVC

-(void)refresh{
    self.pathLabel.text = [RemoteObject getCurrentDatacenterVO].name;
    self.titleLabel.text = self.poolVO.resourcePoolName;
        
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:4];
    
    PoolDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PoolDetailInfoVC"];
    detailVC.poolVO = self.poolVO;
    [pages addObject:detailVC];
    
    PoolHostCollectionVC *poolHostCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PoolHostCollectionVC"];
    poolHostCollectionVC.poolVO = self.poolVO;
    [pages addObject:poolHostCollectionVC];
    
    PoolVmCollectionVC *poolVmCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PoolVmCollectionVC"];
    poolVmCollectionVC.poolVO = self.poolVO;
    [pages addObject:poolVmCollectionVC];
    
    PoolStorageCollectionVC *poolStorageCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PoolStorageCollectionVC"];
    poolStorageCollectionVC.poolVO = self.poolVO;
    [pages addObject:poolStorageCollectionVC];
    
    self.pages = pages;
    
    [super refresh];
}

@end
