//
//  HostVmCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HostVmCollectionVC.h"
#import "MasterCollectionHeader.h"

@implementation HostVmCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.cellIdentifier = @"HostVmCollectionCell";    
}
-(void)reloadData{
    [self.hostVO getVmListAsync:^(NSArray *allRemote, NSError *error) {
        [self.dataList setValue:allRemote forKey:self.hostVO.hostName];
        [self.collectionView reloadData];
    }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"虚拟机列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}


@end
