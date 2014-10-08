//
//  HostCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterHostCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "HostContainerVC.h"
#import "DatacenterMoreVC.h"

@implementation DatacenterHostCollectionVC

-(void)reloadData{
    if(self.isMore){
        [self.poolVO getHostListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
            [self.collectionView reloadData];
        }];
    }else{
        [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
            for(PoolVO *poolVO in allRemote){
                [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                NSMutableArray *hosts = [[NSMutableArray alloc] initWithArray:[poolVO getHostLisWithlimit:7 error:nil]];
                NSString *needMoreButton = @"FALSE";
                
                if(hosts.count==7){
                    needMoreButton = @"TRUE";
                    [hosts removeObjectAtIndex:6];
                }
                
                [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                [self.dataList setValue:hosts forKey:poolVO.resourcePoolName];
            }
            [self.collectionView reloadData];
        }];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterHostCollectionCell" forIndexPath:indexPath];
   
    HostVO *hostVO = (HostVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = hostVO.hostName;
    cell.label1.text = hostVO.ip;
    cell.label2.text = [NSString stringWithFormat:@"%d",hostVO.virtualMachineNum ];
    cell.label3.text = [NSString stringWithFormat:@"%.2fGB",hostVO.storage];
    cell.status.text = [hostVO state_text];
    cell.status.textColor = [hostVO state_color];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"%@下的物理机列表", self.dataList.allKeys[indexPath.section]];
        //header.moreButton.hidden = [[self.pools_needMoreButton valueForKey:self.pools_needMoreButton.allKeys[indexPath.section]] isEqualToString:@"FALSE"];
        header.moreButton.tag = indexPath.section;
    }
    
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HostContainerVC *vc = [[UIStoryboard storyboardWithName:@"Host" bundle:nil] instantiateInitialViewController];
    vc.hostVO = (HostVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
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
