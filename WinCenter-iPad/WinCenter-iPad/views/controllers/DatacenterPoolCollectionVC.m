//
//  PoolCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterPoolCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "PoolContainerVC.h"
#import "DatacenterMoreVC.h"

@implementation DatacenterPoolCollectionVC

-(void)reloadData{
    if(self.isMore){
        [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
            [self.collectionView reloadData];
        }];
    }else{
        [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
            [self.collectionView reloadData];
        } limit:9];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterPoolCollectionCell" forIndexPath:indexPath];
    

    PoolVO *poolVO = (PoolVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = poolVO.resourcePoolName;
    cell.label1.text = [NSString stringWithFormat:@"%d台", poolVO.hostNumber];
    cell.label2.text = [NSString stringWithFormat:@"%d台", poolVO.activeVmNumber];
    cell.label3.text = [NSString stringWithFormat:@"%.0f", poolVO.totalLogicalCpu];
    cell.label4.text = [NSString stringWithFormat:@"%.2fGB", poolVO.totalMemory/1024.0];
    cell.label5.text = [NSString stringWithFormat:@"%.2fGB", poolVO.totalStorage];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleHintView.hidden = YES;
        header.titleLabel.hidden = YES;
        //header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PoolContainerVC *vc = [[UIStoryboard storyboardWithName:@"Pool" bundle:nil] instantiateInitialViewController];
    vc.poolVO = (PoolVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
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
