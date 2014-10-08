//
//  StorageContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "StorageContainerVC.h"
#import "StorageDetailInfoVC.h"

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
    
    StorageDetailInfoVC *vc;
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StorageDetailInfoVC"];
    vc.storageVO = self.storageVO;
    self.pages = @[vc];
    
    [super refresh];
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Datacenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ControlRecordVCNav"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

@end
