//
//  DatacenterDetailVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-15.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "MasterContainerVC.h"
#import "DatacenterVO.h"
#import "DatacenterListResult.h"
#import "MasterCollectionVC.h"
#import "StorageDetailInfoVC.h"
#import "BusinessDetailInfoVC.h"
#import "PoolDetailInfoVC.h"
#import "HostDetailInfoVC.h"
#import "VmDetailInfoVC.h"
#import "VmDetailSnapshootVC.h"
@interface MasterContainerVC ()
@property UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIView *vmControlButtons;
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateVM;
@property (weak, nonatomic) IBOutlet UIButton *btnOperation;
@property (weak, nonatomic) IBOutlet UIView *segmentView_pool;
@property (weak, nonatomic) IBOutlet UIView *segmentView_host;
@property (weak, nonatomic) IBOutlet UIView *segmentView_vm;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfig;
@property (weak, nonatomic) IBOutlet UIButton *buttonTask;
@property (weak, nonatomic) IBOutlet UIButton *buttonWarning;

@property UIPopoverController *popoverVC;

@end

@implementation MasterContainerVC

- (void)didFinished:(DatacenterTableVC *)controller{
    if(self.popoverVC){
        [self.popoverVC dismissPopoverAnimated:YES];
        [self.infoVC refresh];
        [self refresh];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toSelect"]){
        self.popoverVC = [(UIStoryboardPopoverSegue*)segue popoverController];
        UINavigationController *nav = segue.destinationViewController;
        DatacenterTableVC *vc = [[nav viewControllers] firstObject];
        vc.delegate = self;
        vc.datacenterVO = self.datacenterVO;
        
    }else if([segue.identifier isEqualToString:@"toInfoVC"]){
        self.infoVC = segue.destinationViewController;
        self.infoVC.datacenterVO = self.datacenterVO;
    }
    
}

- (void)viewDidLoad
{
    //self.view.backgroundColor = [UIColor colorWithRed:arc4random()%25/255.0 green:arc4random()%25/255.0 blue:arc4random()%25/255.0 alpha:1];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景"]];
    imageView.frame = [[UIScreen mainScreen] bounds];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh{
    switch (self.pageType) {
        case MasterPageType_DATACENTER:{
            self.titleLabel.text = self.datacenterVO.name;
            
            NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:5];
            
            MasterCollectionVC *vc;
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_POOL_BY_DATACENTER;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Pool";
            vc.cellHeader = @"某某数据中心下的资源池列表";
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_HOST_BY_DATACENTER;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Host";
            vc.cellHeader = @"某某资源池下的物理机列表";
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_STORAGE_BY_DATACENTER;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Storage";
            vc.cellHeader = @"某某资源池下的存储池列表";
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_VM_BY_DATACENTER;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_VM";
            vc.cellHeader = @"某某资源池下的虚拟机列表";
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_BUSINESS_BY_DATACENTER;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Business";
            vc.cellHeader = @"某某业务域下的业务系统列表";
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NetworkContainerVC"];
            [pages addObject:vc];
            
            self.pages = pages;
            break;
        }
        case MasterPageType_POOL:{
            self.pathLabel.text = self.datacenterVO.name;
            self.titleLabel.text = ((PoolVO *) self.baseObject).resourcePoolName;
            
            NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:4];
            
            PoolDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PoolDetailInfoVC"];
            detailVC.datacenterVO = self.datacenterVO;
            detailVC.baseObject = (PoolVO *)self.baseObject;
            [pages addObject:detailVC];
            
            MasterCollectionVC *vc;
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_Host";
            vc.cellHeader = @"物理机列表";
            vc.pageType = MasterCollectionType_HOST_BY_POOL;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_VM";
            vc.cellHeader = @"虚拟机列表";
            vc.pageType = MasterCollectionType_VM_BY_POOL;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_Storage";
            vc.cellHeader = @"存储池列表";
            vc.pageType = MasterCollectionType_STORAGE_BY_POOL;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            self.pages = pages;
            break;
        }
        case MasterPageType_POOL_MORE:{
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的资源池列表", self.datacenterVO.name];
            
            MasterCollectionVC *vc;
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_POOL_BY_DATACENTER_MORE;
            vc.datacenterVO = self.datacenterVO;
            vc.poolVO = self.poolVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Pool";
            self.pages = @[vc];
            break;
        }
        case MasterPageType_HOST:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@ - %@", self.datacenterVO.name, ((HostVO *) self.baseObject).resourcePoolName];
            self.titleLabel.text = ((HostVO *) self.baseObject).hostName;
            self.ipLabel.text = ((HostVO *) self.baseObject).ip;
            self.statusLabel.text = [((HostVO*) self.baseObject) state_text];
            
            NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:5];
            
            HostDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HostDetailInfoVC"];
            detailVC.datacenterVO = self.datacenterVO;
            detailVC.baseObject = (HostVO*)self.baseObject;
            [pages addObject:detailVC];
            
            MasterCollectionVC *vc;
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_VM";
            vc.cellHeader = @"虚拟机列表";
            vc.pageType = MasterCollectionType_VM_BY_HOST;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_Storage";
            vc.cellHeader = @"存储池列表";
            vc.pageType = MasterCollectionType_STORAGE_BY_HOST;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_HostNetwork";
            vc.cellHeader = @"虚拟网络列表";
            vc.pageType = MasterCollectionType_HostNetwork;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_HostNic";
            vc.cellHeader = @"网络适配器列表";
            vc.pageType = MasterCollectionType_HostNic;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            self.pages = pages;
            break;
        }
        case MasterPageType_HOST_MORE:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", self.datacenterVO.name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的物理机列表", self.poolVO.resourcePoolName];
            
            MasterCollectionVC *vc;
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_HOST_BY_DATACENTER_MORE;
            vc.datacenterVO = self.datacenterVO;
            vc.poolVO = self.poolVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Host";
            self.pages = @[vc];
            break;
        }
        case MasterPageType_STORAGE:{
            
            if([((StorageVO *) self.baseObject).hostName isEqualToString:@""]){
                self.pathLabel.text = [NSString stringWithFormat:@"%@ - %@", self.datacenterVO.name, ((StorageVO *) self.baseObject).resourcePoolName];
            }else{
                self.pathLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", self.datacenterVO.name, ((StorageVO *) self.baseObject).resourcePoolName, ((StorageVO *) self.baseObject).hostName];
            }
            self.titleLabel.text = ((StorageVO *) self.baseObject).storagePoolName;
            
            StorageDetailInfoVC *vc;
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StorageDetailInfoVC"];
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = (StorageVO *)self.baseObject;
            self.pages = @[vc];
            break;
        }
        case MasterPageType_STORAGE_MORE:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", self.datacenterVO.name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的共享存储列表", self.poolVO.resourcePoolName];
            
            MasterCollectionVC *vc;
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_STORAGE_BY_DATACENTER_MORE;
            vc.datacenterVO = self.datacenterVO;
            vc.poolVO = self.poolVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Storage";
            self.pages = @[vc];
            break;
        }
        case MasterPageType_VM:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", self.datacenterVO.name, ((VmVO *) self.baseObject).poolName, ((VmVO *) self.baseObject).ownerHostName];
            self.titleLabel.text = ((VmVO *) self.baseObject).name;
            self.ipLabel.text = ((VmVO *) self.baseObject).ip;
            self.statusLabel.text = [((VmVO*) self.baseObject) state_text];
            
            NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:4];
            
            VmDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VmDetailInfoVC"];
            detailVC.datacenterVO = self.datacenterVO;
            detailVC.baseObject = (VmVO *) self.baseObject;
            [pages addObject:detailVC];
            
            MasterCollectionVC *vc;
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_VMDisk";
            vc.cellHeader = @"虚拟磁盘列表";
            vc.pageType = MasterCollectionType_VMDisk;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCollectionVC"];
            vc.cellIdentifier = @"MasterCollectionCell_VMNetwork";
            vc.cellHeader = @"虚拟网络列表";
            vc.pageType = MasterCollectionType_VMNetwork;
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = self.baseObject;
            [pages addObject:vc];
            
            VmDetailSnapshootVC *snapshot = [self.storyboard instantiateViewControllerWithIdentifier:@"VmDetailSnapshootVC"];
            [pages addObject:snapshot];
            
            self.pages = pages;
            break;
        }
        case MasterPageType_VM_MORE:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", self.datacenterVO.name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的虚拟机列表", self.poolVO.resourcePoolName];
            
            MasterCollectionVC *vc;
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_VM_BY_DATACENTER_MORE;
            vc.datacenterVO = self.datacenterVO;
            vc.poolVO = self.poolVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_VM";
            
            self.pages = @[vc];
            break;
        }
        case MasterPageType_BUSINESS:{
            self.pathLabel.text = self.datacenterVO.name;
            self.titleLabel.text = ((BusinessVO *)self.baseObject).name;
            
            BusinessDetailInfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BusinessDetailInfoVC"];
            vc.datacenterVO = self.datacenterVO;
            vc.baseObject = (BusinessVO *)self.baseObject;
            self.pages = @[vc];
            break;
        }
        case MasterPageType_BUSINESS_MORE:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", self.datacenterVO.name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的业务系统列表", self.poolVO.resourcePoolName];
            
            MasterCollectionVC *vc;
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterCollectionVC"];
            vc.pageType = MasterCollectionType_BUSINESS_BY_DATACENTER_MORE;
            vc.datacenterVO = self.datacenterVO;
            vc.poolVO = self.poolVO;
            vc.baseObject = self.baseObject;
            vc.cellIdentifier = @"MasterCollectionCell_Business";
            self.pages = @[vc];
            break;
        }
        default:
            break;
    }
    
    
    self.previousIndex = 0;
    self.showIndex = 0;
    
    NSDictionary *options;
    if(self.pageType == MasterPageType_DATACENTER){
        options = @{UIPageViewControllerOptionInterPageSpacingKey: @500};
    }else{
        options = @{UIPageViewControllerOptionInterPageSpacingKey: @150};
    }
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:options];
    [self addChildViewController:self.pageVC];
    for(UIView *subView in self.pageVCContainer.subviews){
        [subView removeFromSuperview];
    }
    [self.pageVCContainer addSubview:self.pageVC.view];
    self.pageVC.view.frame = self.pageVCContainer.bounds;
    [self.pageVC didMoveToParentViewController:self];
    self.view.gestureRecognizers = self.pageVC.gestureRecognizers;
    
    [self.pageVC setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)switchPageVC:(NSInteger)index {
    self.showIndex = index;
    [self.pageVC setViewControllers:@[self.pages[index]] direction:(index>self.previousIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse) animated:NO completion:nil];
    self.previousIndex = index;
    
}

- (IBAction)showControlBtns:(id)sender {
    BOOL isHide = self.vmControlButtons.hidden;
    self.vmControlButtons.hidden = isHide == YES ? NO : YES;
    //   [self.view addSubview:self.vmControlBtns];
    //    self.vmControlBtns.frame.origin.x = 922;
    //    self.vmControlBtns.frame.origin.y = 22;
}
-(void)hideControlBtn{
    self.vmControlButtons.hidden = YES;
}
- (IBAction)openVm:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"虚拟机正在开机..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [self hideControlBtn];
}
- (IBAction)shutdownVm:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"虚拟机正在关机..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [self hideControlBtn];
}
- (IBAction)restartVm:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"虚拟机正在重启..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [self hideControlBtn];
}
- (IBAction)migrateVm:(id)sender {
    [self hideControlBtn];
}

-(IBAction)backToContainVC:(UIStoryboardSegue*)segue{
    
}

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)showOptionsVC:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionsVCNav"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ControlRecordVCNav"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonWarning];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
-(IBAction)showWarningInfoVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WarningInfoVCNav"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
//--------------------

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if(self.pages.count==1) return nil;
    
    NSUInteger index =  [self.pages indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }else{
        index--;
        return self.pages[index];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index =  [self.pages indexOfObject:viewController];
    if (index == self.pages.count - 1) {
        return nil;
    }else{
        index++;
        return self.pages[index];
    }
    
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return self.pages.count;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.showIndex;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    self._selectedIndex = [self.pages indexOfObject:pendingViewControllers[0]];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        self.showIndex = self._selectedIndex;
        if(self.infoVC!=nil){
            [self.infoVC switchButtonSelected:self.showIndex];
        }
    }
}



@end
