//
//  BusinessDetailVC.h
//  wincenterDemo01
//
//  Created by huadi on 14-8-20.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDetailInfoVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *collectionHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property DatacenterVO *datacenterVO;
@property BusinessVO *baseObject;
@property NSArray *dataList;
@end
