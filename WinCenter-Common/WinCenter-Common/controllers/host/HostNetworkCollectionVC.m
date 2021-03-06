//
//  HostNetworkCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HostNetworkCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"

@implementation HostNetworkCollectionVC

-(void)reloadData{
    [self.hostVO getHostNetworkExternalListAsync:^(NSArray *allRemote, NSError *error) {
        [self.dataList setValue:allRemote forKey:@"外部网络"];
        [self.hostVO getHostNetworkInternalListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:@"内部网络"];
            [self.collectionView reloadData];
        }];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HostNetworkCollectionCell" forIndexPath:indexPath];
    
    HostNetworkVO *hostNetworkVO = (HostNetworkVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = hostNetworkVO.name;
    
    cell.label2.text = @"";
    cell.label3.text = @"";
    cell.label4.text = @"";
    cell.label5.text = hostNetworkVO.vlanId;
    cell.label6.text = hostNetworkVO.pniName;
    cell.status.text = [hostNetworkVO state_text];
    cell.linkState.image = [UIImage imageNamed:[hostNetworkVO linkState_image]];
    if(indexPath.section==0){
        cell.type_image.image = [UIImage imageNamed:@"Network_internal"];
    }else{
        cell.type_image.image = [UIImage imageNamed:@"Network_External"];
    }
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
        header.titleLabel.text = [NSString stringWithFormat:@"%@列表(%li)", self.dataList.allKeys[indexPath.section], ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}


@end
