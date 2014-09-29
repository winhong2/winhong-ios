//
//  DatacenterDetailVC.h
//  wincenterDemo01
//
//  Created by huadi on 14-8-15.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatacenterDetailInfoVC.h"
#import "DatacenterTableVC.h"

@class DatacenterDetailInfoVC;

@interface MasterContainerVC : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, DatacenterTableVCDelegate>

@property DatacenterDetailInfoVC *infoVC;

@property DatacenterVO *datacenterVO;
@property PoolVO *poolVO;
@property StorageVO *baseObject;

- (void)switchPageVC:(NSInteger)index;

@property MasterPageType pageType;

@property (weak, nonatomic) IBOutlet UIView *pageVCContainer;
@property UIPageViewController *pageVC;
@property NSArray *pages;
@property NSInteger _selectedIndex;
@property NSInteger previousIndex;
@property NSInteger showIndex;

-(IBAction)backToContainVC:(UIStoryboardSegue*)segue;

-(IBAction)backAction:(id)sender;
-(IBAction)showOptionsVC:(id)sender;
-(IBAction)showControlRecordVC:(id)sender;
-(IBAction)showWarningInfoVC:(id)sender;

@end
