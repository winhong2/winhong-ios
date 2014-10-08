//
//  PoolContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PoolContainerVC.h"
#import "PoolDetailInfoVC.h"
#import "HostCollectionVC.h"
#import "VmCollectionVC.h"
#import "StorageCollectionVC.h"
#import "PopControlRecordVC.h"

@implementation PoolContainerVC

-(void)refresh{
    self.pathLabel.text = [RemoteObject getCurrentDatacenterVO].name;
    self.titleLabel.text = self.poolVO.resourcePoolName;
        
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:4];
    
    PoolDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PoolDetailInfoVC"];
    detailVC.poolVO = self.poolVO;
    [pages addObject:detailVC];
    
    HostCollectionVC *poolHostCollectionVC = [[UIStoryboard storyboardWithName:@"Host" bundle:nil] instantiateViewControllerWithIdentifier:@"HostCollectionVC"];
    poolHostCollectionVC.poolVO = self.poolVO;
    [pages addObject:poolHostCollectionVC];
    
    VmCollectionVC *poolVmCollectionVC = [[UIStoryboard storyboardWithName:@"VM" bundle:nil] instantiateViewControllerWithIdentifier:@"VmCollectionVC"];
    poolVmCollectionVC.poolVO = self.poolVO;
    [pages addObject:poolVmCollectionVC];
    
    StorageCollectionVC *poolStorageCollectionVC = [[UIStoryboard storyboardWithName:@"Storage" bundle:nil] instantiateViewControllerWithIdentifier:@"StorageCollectionVC"];
    poolStorageCollectionVC.poolVO = self.poolVO;
    [pages addObject:poolStorageCollectionVC];
    
    self.pages = pages;
    
    [super refresh];
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Datacenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ControlRecordVCNav"];
    PopControlRecordVC *controlVC = [[nav childViewControllers] firstObject];
    controlVC.remoteObject = self.poolVO;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

@end