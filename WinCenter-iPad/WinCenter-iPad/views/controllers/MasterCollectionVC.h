//
//  DatacenterDetailCollectionVC.h
//  wincenterDemo01
//
//  Created by apple on 14-8-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCollectionVC : UICollectionViewController
@property DatacenterVO *datacenterVO;
@property PoolVO *poolVO;
@property BaseObject *baseObject;

@property MasterCollectionType pageType;
@property NSString *cellIdentifier;
@property NSString *cellHeader;

@end
