//
//  PoolHostCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PoolHostCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "HostContainerVC.h"

@implementation PoolHostCollectionVC

-(void)reloadData{
    [self.poolVO getHostListAsync:^(NSArray *allRemote, NSError *error) {
        [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PoolHostCollectionCell" forIndexPath:indexPath];
    
    HostVO *hostVO = (HostVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = hostVO.hostName;
    cell.label1.text = hostVO.ip;
    cell.label2.text = [NSString stringWithFormat:@"%d",hostVO.virtualMachineNum];
    cell.label3.text = [NSString stringWithFormat:@"%d",hostVO.cpuSlots];
    cell.label4.text = [NSString stringWithFormat:@"%d",hostVO.cpu];
    cell.label5.text = [NSString stringWithFormat:@"%.2fGB",hostVO.memory/1024.0];
    cell.status.text = [hostVO state_text];
    cell.status.textColor = [hostVO state_color];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
            header.titleLabel.text = [NSString stringWithFormat:@"物理机列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HostContainerVC *vc = [[UIStoryboard storyboardWithName:@"Host" bundle:nil] instantiateInitialViewController];
    vc.hostVO = (HostVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
