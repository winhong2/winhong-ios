//
//  VmCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterVmCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "VmContainerVC.h"
#import "DatacenterMoreVC.h"

@implementation DatacenterVmCollectionVC

-(void)reloadData{
    if(self.isMore){
        [self.poolVO getVmListAsync:^(NSArray *allRemote, NSError *error) {
            [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
            [self.collectionView reloadData];
        }];
    }else{
        [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
            for(PoolVO *poolVO in allRemote){            
                [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                
                NSMutableArray *vms = [[NSMutableArray alloc] initWithArray:[poolVO getVmListWithlimit:7 error:nil]];
                NSString *needMoreButton = @"FALSE";
                
                if(vms.count==7){
                    needMoreButton = @"TRUE";
                    [vms removeObjectAtIndex:6];
                }
                
                [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                [self.dataList setValue:vms forKey:poolVO.resourcePoolName];
            }
            [self.collectionView reloadData];
        }];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterVmCollectionCell" forIndexPath:indexPath];
    
    VmVO *vmVO = (VmVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
    cell.title.text = vmVO.name;
    cell.label1.text = vmVO.ip;
    cell.label2.text = [NSString stringWithFormat:@"%d", vmVO.vcpu];
    cell.label3.text = [NSString stringWithFormat:@"%.2fGB", vmVO.memory/1024.0];
    cell.label4.text = [NSString stringWithFormat:@"%dGB", vmVO.storage];
    cell.status.text = [vmVO state_text];
    cell.status.textColor = [vmVO state_color];
    cell.osType_image.image = [UIImage imageNamed:[vmVO osType_imageName]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"%@下的虚拟机列表", self.dataList.allKeys[indexPath.section]];
        //header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<3);
        header.moreButton.tag = indexPath.section;
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VmContainerVC *vc = [[UIStoryboard storyboardWithName:@"VM" bundle:nil] instantiateInitialViewController];
    vc.vmVO = (VmVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
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
