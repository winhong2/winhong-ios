//
//  DatacenterDetailCollectionVC.h
//  wincenterDemo01
//
//  Created by apple on 14-8-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCollectionVC : UICollectionViewController

@property NSMutableDictionary *pools;
@property NSMutableDictionary *pools_needMoreButton;
@property NSMutableDictionary *dataList;

-(void)reloadData;

@end
