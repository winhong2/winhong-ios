//
//  VmNicCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "VmDiskCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"

@implementation VmDiskCollectionVC

-(void)reloadData{
    [self.vmVO getVmVolumnListAsync:^(NSArray *allRemote, NSError *error) {
        [self.dataList setValue:allRemote forKey:self.vmVO.name];
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VmDiskCollectionCell" forIndexPath:indexPath];

    VmDiskVO *vmDiskVO = (VmDiskVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = vmDiskVO.name;
    cell.label1.text = [vmDiskVO type_text];
    cell.label2.text = vmDiskVO.storagePoolName;
    cell.label3.text = [NSString stringWithFormat:@"%dGB", vmDiskVO.size];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"虚拟磁盘列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}


@end
