//
//  VmNetworkCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "VmNetworkCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"

@implementation VmNetworkCollectionVC

-(void)reloadData{
    [self.vmVO getVmNicListAsync:^(NSArray *allRemote, NSError *error) {
        [self.dataList setValue:allRemote forKey:self.vmVO.name];
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VmNetworkCollectionCell" forIndexPath:indexPath];

    VmNetworkVO *vmNetworkVO = (VmNetworkVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = vmNetworkVO.name;
    cell.label1.text = [vmNetworkVO type_text];
    cell.label2.text = vmNetworkVO.ip;
    cell.label3.text = vmNetworkVO.macAddr;
    cell.label4.text = [NSString stringWithFormat:@"%d", vmNetworkVO.vlanId];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:0.08];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"虚拟网络列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}


@end
