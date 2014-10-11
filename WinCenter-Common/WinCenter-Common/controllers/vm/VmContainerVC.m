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
    
    self.title = self.vmVO.name;
    
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
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        PopControlRecordVC *controlVC = [[UIStoryboard storyboardWithName:@"Task"] instantiateViewControllerWithIdentifier:@"PopControlRecordVC"];
        controlVC.remoteObject = self.vmVO;
        [pages addObject:controlVC];
    }
    
    self.pages = pages;
    
    [super refresh];
    
    if ([self.vmVO.state isEqualToString:@"OK"]) {
        self.btnStart.enabled = false;
        self.btnStop.enabled = true;
        self.btnRestart.enabled = true;
        self.btnMigrate.enabled = true;
    }else if([self.vmVO.state isEqualToString:@"STOPPED"]){
        self.btnStart.enabled = true;
        self.btnStop.enabled = false;
        self.btnRestart.enabled = false;
        self.btnMigrate.enabled = true;
    }
}
- (IBAction)operateAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"操作提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开机",@"关机",@"重启",@"迁移", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self openVm:nil];
            break;
        case 1:
            [self shutdownVm:nil];
            break;
        case 2:
            [self restartVm:nil];
            break;
        case 3:
            [self migrateVm:nil];
            break;
        default:
            break;
    }
}

- (IBAction)showControlBtns:(id)sender {
    if(self.vmControlButtons){
        BOOL isHide = self.vmControlButtons.hidden;
        self.vmControlButtons.hidden = isHide == YES ? NO : YES;
    }
}
-(void)hideControlBtn{
    if(self.vmControlButtons){
        self.vmControlButtons.hidden = YES;
    }
}
- (IBAction)openVm:(id)sender {
    [self.vmVO VmOperation:@"OK" async:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"虚拟机正在开机..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self hideControlBtn];
    }];
}
- (IBAction)shutdownVm:(id)sender {
    [self.vmVO VmOperation:@"STOPPED" async:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"虚拟机正在关机..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self hideControlBtn];
    }];
}
- (IBAction)restartVm:(id)sender {
    [self.vmVO VmOperation:@"RESTART" async:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"虚拟机正在重启..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self hideControlBtn];
    }];
}
- (IBAction)migrateVm:(id)sender {
    [self hideControlBtn];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [self performSegueWithIdentifier:@"toMigrate" sender:self];
    }
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task"] instantiateInitialViewController];
    PopControlRecordVC *controlVC = [[nav childViewControllers] firstObject];
    controlVC.remoteObject = self.vmVO;
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
    controlVC.remoteObject = self.vmVO;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
@end
