//
//  BusinessVmCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "BusinessVmCollectionVC.h"
#import "BusinessVmCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "VmContainerVC.h"

@interface BusinessVmCollectionVC ()

@end

@implementation BusinessVmCollectionVC

- (void)viewDidLoad
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.collectionView.backgroundColor = [UIColor clearColor];
    }
    
    [super viewDidLoad];
    
    [self.businessVO getBusinessVmListAsync:^(NSArray *allRemote, NSError *error) {
        self.dataList = allRemote;
        [self.collectionView reloadData];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BusinessVmCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BusinessVmCollectionCell" forIndexPath:indexPath];
    
    BusinessVmVO *vmvo = (BusinessVmVO*)self.dataList[indexPath.row];
    cell.name.text = vmvo.name;
    cell.startOrder.text = [NSString stringWithFormat:@"%d", vmvo.startOrder];
    cell.delayInterval.text = [NSString stringWithFormat:@"%d", vmvo.delayInterval];
    cell.state.text = [vmvo state_text];
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
        header.titleLabel.text = [NSString stringWithFormat:@"虚拟机(%li)", self.dataList.count];
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *root = [[UIStoryboard storyboardWithName:@"VM"] instantiateInitialViewController];
    VmContainerVC *vc;
    if([root isKindOfClass:[VmContainerVC class]]){
        vc = (VmContainerVC*) root;
    }else{
        vc = [[root childViewControllers] firstObject];
    }
    BusinessVmVO *businessVmvo = (BusinessVmVO*)self.dataList[indexPath.row];
    VmVO *vmvo = [[VmVO alloc] init];
    vmvo.vmId = businessVmvo.vmId;
    vmvo.name = businessVmvo.name;
    vc.vmVO = vmvo;
    [self presentViewController:root animated:YES completion:nil];
}
@end
