//
//  HostStorageCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HostStorageCollectionVC.h"
#import "MasterCollectionHeader.h"

@implementation HostStorageCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.cellIdentifier = @"HostStorageCollectionCell";    
}

-(void)reloadData{
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    if(header){
        header.titleLabel.text = [NSString stringWithFormat:@"本地存储列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
    }
    
    return header;
}


@end
