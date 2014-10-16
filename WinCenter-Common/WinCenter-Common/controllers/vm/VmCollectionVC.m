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
    cell.progress_1.litEffect = NO;
    cell.progress_1.numBars = 10;
    cell.progress_1.value = 1;
    cell.progress_1.backgroundColor = [UIColor clearColor];
    cell.progress_1.outerBorderColor = [UIColor clearColor];
    cell.progress_1.innerBorderColor = [UIColor clearColor];
    
    cell.progress_2.litEffect = NO;
    cell.progress_2.numBars = 10;
    cell.progress_2.value = 1;
    cell.progress_2.backgroundColor = [UIColor clearColor];
    cell.progress_2.outerBorderColor = [UIColor clearColor];
    cell.progress_2.innerBorderColor = [UIColor clearColor];
    
    cell.progress_3.litEffect = NO;
    cell.progress_3.numBars = 10;
    cell.progress_3.value = 1;
    cell.progress_3.backgroundColor = [UIColor clearColor];
    cell.progress_3.outerBorderColor = [UIColor clearColor];
    cell.progress_3.innerBorderColor = [UIColor clearColor];
    
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
    UIViewController *root = [[UIStoryboard storyboardWithName:@"VM"] instantiateInitialViewController];
    VmContainerVC *vc;
    if([root isKindOfClass:[VmContainerVC class]]){
        vc = (VmContainerVC*) root;
    }else{
        vc = [[root childViewControllers] firstObject];
    }
    vc.vmVO = (VmVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:root animated:YES completion:nil];
}

@end
