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

@interface MasterContainerVC : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (void)switchPageVC:(NSInteger)index;

@property (weak, nonatomic) IBOutlet UIView *pageVCContainer;
@property UIPageViewController *pageVC;
@property NSArray *pages;
@property NSInteger _selectedIndex;
@property NSInteger previousIndex;
@property NSInteger showIndex;

@property UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateVM;
@property (weak, nonatomic) IBOutlet UIButton *btnOperation;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfig;
@property (weak, nonatomic) IBOutlet UIButton *buttonTask;
@property (weak, nonatomic) IBOutlet UIButton *buttonWarning;

@property UIPopoverController *popoverVC;

-(IBAction)backToContainVC:(UIStoryboardSegue*)segue;

-(IBAction)backAction:(id)sender;
-(IBAction)showOptionsVC:(id)sender;
-(IBAction)showControlRecordVC:(id)sender;
-(IBAction)showWarningInfoVC:(id)sender;
- (void)refresh;

@end
