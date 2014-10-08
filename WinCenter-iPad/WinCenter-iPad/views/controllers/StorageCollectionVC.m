//
//  PoolStorageCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "StorageCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "StorageContainerVC.h"

@implementation StorageCollectionVC

-(void)reloadData{
    if(self.poolVO){
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
    }else{
        [self.hostVO getStorageListAsync:^(NSArray *allRemote, NSError *error) {
            NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
            for(StorageVO *item in allRemote){
                if([item.shared isEqualToString:@"false"]){//非共享
                    [shareList addObject:item];
                }
            }
            [self.dataList setValue:shareList forKey:self.hostVO.hostName];
            [self.collectionView reloadData];
        }];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StorageCollectionCell" forIndexPath:indexPath];
    
    StorageVO *storageVO = (StorageVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = storageVO.storagePoolName;
    cell.label1.text = storageVO.type;
    cell.label2.text = storageVO.location;
    cell.label3.text = [NSString stringWithFormat:@"%d个", storageVO.volumeNum];
    cell.label4.text = [NSString stringWithFormat:@"%.2fGB剩余,共%.2fGB", storageVO.availStorage, storageVO.totalStorage];
    cell.status.text = [storageVO state_text];
    cell.status.textColor = [storageVO state_color];
    cell.share_image.hidden = [storageVO.shared isEqualToString:@"false"];
    cell.progress.progress = (storageVO.totalStorage-storageVO.availStorage)/storageVO.totalStorage;
    if(cell.progress.progress>0.8){
        cell.progress.progressTintColor = PNRed;
    }else if(cell.progress.progress>0.6){
        cell.progress.progressTintColor = PNYellow;
    }else{
        cell.progress.progressTintColor = PNGreen;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        if(self.poolVO){
            header.titleLabel.text = [NSString stringWithFormat:@"共享存储列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
        }else{
            header.titleLabel.text = [NSString stringWithFormat:@"本地存储列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
        }
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StorageContainerVC *vc = [[UIStoryboard storyboardWithName:@"Storage" bundle:nil] instantiateInitialViewController];
    vc.storageVO = (StorageVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
