//
//  DatacenterDetailCollectionVC.m
//  wincenterDemo01
//
//  Created by apple on 14-8-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MasterCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "PoolListResult.h"
#import "PoolVO.h"
#import "HostVO.h"
#import "HostListResult.h"
#import "StorageVO.h"
#import "StorageListResult.h"
#import "VmVO.h"
#import "VmListResult.h"
#import "BusinessVO.h"
#import "BusinessListResult.h"
#import "NetworkVO.h"
#import "NetworkListResult.h"
#import "MasterContainerVC.h"

@implementation MasterCollectionVC

-(void)reloadData{
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
}
- (void)viewDidLoad
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.collectionView.backgroundColor = [UIColor clearColor];
    }
    
    self.pools = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    self.pools_needMoreButton = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    self.dataList = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    
    [super viewDidLoad];
    
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataList.allKeys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[section]]).count;
}

-(IBAction)backToCollectionVC:(UIStoryboardSegue*)segue{
    
}

@end
