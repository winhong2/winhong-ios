//
//  PoolVmCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "VmCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "VmContainerVC.h"

@implementation VmCollectionVC

-(void)reloadData{
    if(self.poolVO){
        [self.poolVO getVmListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
            [self.collectionView reloadData];
        }];
    }else{
        [self.hostVO getVmListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:self.hostVO.hostName];
            [self.collectionView reloadData];
        }];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VmCollectionCell" forIndexPath:indexPath];
    
    VmVO *vmVO = (VmVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = vmVO.name;
    cell.label1.text = vmVO.ip;
    if(vmVO.ip == nil){
        cell.label1.text = @"(尚未配置ip)";
    }
    cell.label2.text = [NSString stringWithFormat:@"%d", vmVO.vcpu];
    cell.label3.text = [NSString stringWithFormat:@"%.2fGB", vmVO.memory/1024.0];
    cell.label4.text = [NSString stringWithFormat:@"%dGB", vmVO.storage];
    cell.status.text = [vmVO state_text];
    cell.status.textColor = [vmVO state_color];
    cell.osType.text = vmVO.osType;
    cell.osType_image.image = [UIImage imageNamed:[vmVO osType_imageName]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"虚拟机列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VmContainerVC *vc = [[UIStoryboard storyboardWithName:@"VM" bundle:nil] instantiateInitialViewController];
    vc.vmVO = (VmVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
