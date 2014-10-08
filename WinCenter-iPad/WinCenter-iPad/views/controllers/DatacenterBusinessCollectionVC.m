//
//  BusinessCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterBusinessCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "BusinessContainerVC.h"
#import "DatacenterMoreVC.h"

@implementation DatacenterBusinessCollectionVC

-(void)reloadData{
    if(self.isMore){
        [[RemoteObject getCurrentDatacenterVO] getBusinessListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
            [self.collectionView reloadData];
        }];
    }else{
        [[RemoteObject getCurrentDatacenterVO] getBusinessListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
            [self.collectionView reloadData];
        } limit:9];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterBusinessCollectionCell" forIndexPath:indexPath];
    
    BusinessVO *businessVO = (BusinessVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = businessVO.name;
    cell.label1.text = businessVO.managerId;
    cell.label2.text = [businessVO.createTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
    cell.label3.text = [NSString stringWithFormat:@"%d", businessVO.vmNum];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleHintView.hidden = YES;
        header.titleLabel.hidden = YES;
        header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BusinessContainerVC *vc = [[UIStoryboard storyboardWithName:@"Business" bundle:nil] instantiateInitialViewController];
    vc.businessVO = (BusinessVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
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
