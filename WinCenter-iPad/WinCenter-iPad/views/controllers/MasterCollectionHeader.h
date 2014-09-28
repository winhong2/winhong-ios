//
//  DatacenterDetailCollectionHeader.h
//  wincenterDemo01
//
//  Created by apple on 14-8-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterCollectionVC.h"

@interface MasterCollectionHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet MasterCollectionVC *delegate;
@property (weak, nonatomic) IBOutlet UIView *titleHintView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end
