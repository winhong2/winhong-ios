//
//  StorageCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterStorageCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "StorageContainerVC.h"
#import "DatacenterMoreVC.h"

@implementation DatacenterStorageCollectionVC

-(void)reloadData{
    if(self.isMore){
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
        [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
            for(PoolVO *poolVO in allRemote){            
                NSArray *storageList = [poolVO getStorageList:nil];
                NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
                NSString *needMoreButton = @"FALSE";
                int count = 0;
                for(StorageVO *item in storageList){
                    if([item.shared isEqualToString:@"true"]){
                        count++;
                        if(count==7){
                            needMoreButton = @"TRUE";
                            break;
                        }
                        [shareList addObject:item];
                    }
                }
                //if(shareList.count>0){
                [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                [self.dataList setValue:shareList forKey:poolVO.resourcePoolName];
                //}
            }
            [self.collectionView reloadData];
        }];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterStorageCollectionCell" forIndexPath:indexPath];
   
    StorageVO *storageVO = (StorageVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = storageVO.storagePoolName;
    cell.label1.text = [NSString stringWithFormat:@"%.2fGB剩余,共%.2fGB", storageVO.availStorage, storageVO.totalStorage];
    cell.label2.text = [NSString stringWithFormat:@"%d个", storageVO.volumeNum];
    cell.status.text = [storageVO state_text];
    //cell.share.text = [storageVO shared_text];
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
        header.titleLabel.text = [NSString stringWithFormat:@"%@下的共享存储列表", self.dataList.allKeys[indexPath.section]];
        //header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<3);
        header.moreButton.tag = indexPath.section;
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StorageContainerVC *vc = [[UIStoryboard storyboardWithName:@"Storage" bundle:nil] instantiateInitialViewController];
    vc.storageVO = (StorageVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMore"]){
        DatacenterMoreVC *vc = segue.destinationViewController;
        if(self.pools.allKeys.count>0){
            vc.poolVO = [self.pools valueForKey:self.pools.allKeys[((UIButton*)sender).tag]];
        }
    }
}


@end
