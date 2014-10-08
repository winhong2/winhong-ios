//
//  VmContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "VmContainerVC.h"
#import "MasterCollectionVC.h"
#import "VmDetailInfoVC.h"
#import "VmDetailSnapshootVC.h"
#import "VmNetworkCollectionVC.h"
#import "VmDiskCollectionVC.h"
#import "PopControlRecordVC.h"

@implementation VmContainerVC

-(void)refresh{
    self.pathLabel.text = [NSString stringWithFormat:@"%@ → %@ → %@", [RemoteObject getCurrentDatacenterVO].name, self.vmVO.poolName, self.vmVO.ownerHostName];
    self.titleLabel.text = self.vmVO.name;
    self.ipLabel.text = self.vmVO.ip;
    if(self.vmVO.ip == nil){
        self.ipLabel.text = @"(尚未配置ip)";
    }
    self.statusLabel.text = [self.vmVO state_text];
    self.statusLabel.textColor = [self.vmVO state_color];
    
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:4];
    
    VmDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VmDetailInfoVC"];
    detailVC.vmVO = self.vmVO;
    [pages addObject:detailVC];
        
    VmNetworkCollectionVC *vmNetworkCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VmNetworkCollectionVC"];
    vmNetworkCollectionVC.vmVO = self.vmVO;
    [pages addObject:vmNetworkCollectionVC];
    
    VmDiskCollectionVC *vmDiskCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VmDiskCollectionVC"];
    vmDiskCollectionVC.vmVO = self.vmVO;
    [pages addObject:vmDiskCollectionVC];
    
    VmDetailSnapshootVC *snapshot = [self.storyboard instantiateViewControllerWithIdentifier:@"VmDetailSnapshootVC"];
    [pages addObject:snapshot];
    
    self.pages = pages;
    
    [super refresh];
}

- (IBAction)showControlBtns:(id)sender {
    BOOL isHide = self.vmControlButtons.hidden;
    self.vmControlButtons.hidden = isHide == YES ? NO : YES;
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

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Datacenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ControlRecordVCNav"];
    PopControlRecordVC *controlVC = [[nav childViewControllers] firstObject];
    controlVC.remoteObject = self.vmVO;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
@end
