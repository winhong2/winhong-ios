//
//  PoolHostCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HostCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "HostContainerVC.h"

@implementation HostCollectionVC

-(void)reloadData{
    [self.poolVO getHostListAsync:^(NSArray *allRemote, NSError *error) {
        [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HostCollectionCell" forIndexPath:indexPath];
    
    HostVO *hostVO = (HostVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = hostVO.hostName;
    cell.label1.text = hostVO.ip;
    cell.label2.text = [NSString stringWithFormat:@"%d",hostVO.virtualMachineNum];
    cell.label3.text = [NSString stringWithFormat:@"%d",hostVO.cpuSlots];
    cell.label4.text = [NSString stringWithFormat:@"%d",hostVO.cpu];
    cell.label5.text = [NSString stringWithFormat:@"%.2fGB",hostVO.memory/1024.0];
    cell.label6.text = [NSString stringWithFormat:@"%.2fGB",hostVO.storage];
    cell.status.text = [hostVO state_text];
    cell.status.textColor = [hostVO state_color];
    
    cell.progress_vm.litEffect = NO;
    cell.progress_vm.numBars = 10;
    cell.progress_vm.value = 1;
    cell.progress_vm.backgroundColor = [UIColor clearColor];
    cell.progress_vm.outerBorderColor = [UIColor clearColor];
    cell.progress_vm.innerBorderColor = [UIColor clearColor];
    
    cell.progress_storage.litEffect = NO;
    cell.progress_storage.numBars = 10;
    cell.progress_storage.value = 1;
    cell.progress_storage.backgroundColor = [UIColor clearColor];
    cell.progress_storage.outerBorderColor = [UIColor clearColor];
    cell.progress_storage.innerBorderColor = [UIColor clearColor];
    
    cell.progress_CPUCount.litEffect = NO;
    cell.progress_CPUCount.numBars = 10;
    cell.progress_CPUCount.value = 1;
    cell.progress_CPUCount.backgroundColor = [UIColor clearColor];
    cell.progress_CPUCount.outerBorderColor = [UIColor clearColor];
    cell.progress_CPUCount.innerBorderColor = [UIColor clearColor];
    
    cell.progress_CPUUnit.litEffect = NO;
    cell.progress_CPUUnit.numBars = 10;
    cell.progress_CPUUnit.value = 1;
    cell.progress_CPUUnit.backgroundColor = [UIColor clearColor];
    cell.progress_CPUUnit.outerBorderColor = [UIColor clearColor];
    cell.progress_CPUUnit.innerBorderColor = [UIColor clearColor];
    
    cell.progress_memory.litEffect = NO;
    cell.progress_memory.numBars = 10;
    cell.progress_memory.value = 1;
    cell.progress_memory.backgroundColor = [UIColor clearColor];
    cell.progress_memory.outerBorderColor = [UIColor clearColor];
    cell.progress_memory.innerBorderColor = [UIColor clearColor];
    
    
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
    UIViewController *root = [[UIStoryboard storyboardWithName:@"Host"] instantiateInitialViewController];
    HostContainerVC *vc;
    if([root isKindOfClass:[HostContainerVC class]]){
        vc = (HostContainerVC*) root;
    }else{
        vc = [[root childViewControllers] firstObject];
    }
    vc.hostVO = (HostVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:root animated:YES completion:nil];
}


@end
