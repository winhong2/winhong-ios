//
//  StorageDetailVC.h
//  wincenterDemo01
//
//  Created by huadi on 14-8-18.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageDetailInfoVC : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property StorageVO *storageVO;
@property NSArray *dataList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *collectionHeader;

@end
