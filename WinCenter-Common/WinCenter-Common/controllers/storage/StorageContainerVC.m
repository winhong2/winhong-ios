//
//  StorageContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "StorageContainerVC.h"
#import "StorageDetailInfoVC.h"
#import "PopControlRecordVC.h"

@implementation StorageContainerVC

-(void)refresh{
    if((self.storageVO.hostName ==nil) || [self.storageVO.hostName isEqualToString:@""]){
        self.pathLabel.text = [NSString stringWithFormat:@"%@ → %@", [RemoteObject getCurrentDatacenterVO].name, self.storageVO.resourcePoolName];
    }else{
        self.pathLabel.text = [NSString stringWithFormat:@"%@ → %@ → %@", [RemoteObject getCurrentDatacenterVO].name, self.storageVO.resourcePoolName, self.storageVO.hostName];
    }
    self.titleLabel.text = self.storageVO.storagePoolName;
    self.statusLabel.text = [self.storageVO state_text];
    self.statusLabel.textColor = [self.storageVO state_color];
    
    self.title = self.storageVO.storagePoolName;
    
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:1];
    
    StorageDetailInfoVC *vc;
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StorageDetailInfoVC"];
    vc.storageVO = self.storageVO;
    [pages addObject:vc];
    
    if(self.hasDiskPage){
        StorageDiskCollectionVC *diskCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StorageDiskCollectionVC"];
        diskCollectionVC.storageVO = self.storageVO;
        [pages addObject:diskCollectionVC];
    }
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        StorageDiskCollectionVC *diskCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StorageDiskCollectionVC"];
        diskCollectionVC.storageVO = self.storageVO;
        [pages addObject:diskCollectionVC];
        
        PopControlRecordVC *controlVC = [[UIStoryboard storyboardWithName:@"Task"] instantiateViewControllerWithIdentifier:@"PopControlRecordVC"];
        controlVC.remoteObject = self.storageVO;
        [pages addObject:controlVC];
    }
    
    self.pages = pages;
    
    [super refresh];
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task"] instantiateInitialViewController];
    PopControlRecordVC *controlVC = [[nav childViewControllers] firstObject];
    controlVC.remoteObject = self.storageVO;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIButton *button = (UIButton*)sender;
    //self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(IBAction)showControlRecordVCWithBarItem:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task"] instantiateInitialViewController];
    PopControlRecordVC *controlVC = [[nav childViewControllers] firstObject];
    controlVC.remoteObject = self.storageVO;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

@end
