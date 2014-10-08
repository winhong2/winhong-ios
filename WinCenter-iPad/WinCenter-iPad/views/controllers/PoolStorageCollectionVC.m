//
//  PoolStorageCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PoolStorageCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "StorageContainerVC.h"

@implementation PoolStorageCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.cellIdentifier = @"PoolStorageCollectionCell";    
}

-(void)reloadData{
    [self.poolVO getStorageListAsync:^(NSArray *allRemote, NSError *error) {
        NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
        for(StorageVO *item in allRemote){
            if([item.shared isEqualToString:@"true"]){
                [shareList addObject:item];
            }
        }
        [self.dataList setValue:shareList forKey:self.poolVO.resourcePoolName];
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    StorageVO *storageVO = (StorageVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = storageVO.storagePoolName;
    cell.label1.text = storageVO.type;
    cell.label2.text = storageVO.location;
    cell.label3.text = [NSString stringWithFormat:@"%d个", storageVO.volumeNum];
    cell.label4.text = [NSString stringWithFormat:@"%.2fGB剩余,共%.2fGB", storageVO.availStorage, storageVO.totalStorage];
    cell.status.text = [storageVO state_text];
    cell.status.textColor = [storageVO state_color];
    cell.share.text = [storageVO shared_text];
    cell.progress.progress = (storageVO.totalStorage-storageVO.availStorage)/storageVO.totalStorage;
    if(cell.progress.progress>0.8){
        cell.progress.progressTintColor = [UIColor redColor];
    }else if(cell.progress.progress>0.6){
        cell.progress.progressTintColor = [UIColor yellowColor];
    }else{
        cell.progress.progressTintColor = [UIColor greenColor];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"共享存储列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StorageContainerVC *vc = [[UIStoryboard storyboardWithName:@"Storage" bundle:nil] instantiateInitialViewController];
    vc.storageVO = (StorageVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
