//
//  StorageVmCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "StorageDiskCollectionVC.h"
#import "StorageDiskCollectionCell.h"
#import "MasterCollectionHeader.h"

@interface StorageDiskCollectionVC ()

@end

@implementation StorageDiskCollectionVC

- (void)viewDidLoad{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.collectionView.backgroundColor = [UIColor clearColor];
    }
    
    [super viewDidLoad];
    
    [self.storageVO getStorageVolumnListAsync:^(NSArray *allRemote, NSError *error) {
        self.dataList = allRemote;
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StorageDiskCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StorageDiskCollectionCell" forIndexPath:indexPath];
    
    StorageVolumnVO *volumnVO = self.dataList[indexPath.row];
    cell.name.text = volumnVO.name;
    cell.state.text = [volumnVO state_text];
    cell.isASnapshot.text = [volumnVO isASnapshot_text];
    cell.size.text = [NSString stringWithFormat:@"%dGB", volumnVO.size];
    cell.belongsVM.text = [volumnVO vmNames_text];
    cell.type.text = [volumnVO type_text];
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
        header.titleLabel.text = [NSString stringWithFormat:@"虚拟磁盘(%li)", self.dataList.count];
    }
    
    return header;
}


@end
