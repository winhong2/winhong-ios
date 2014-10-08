//
//  HostContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HostContainerVC.h"
#import "HostDetailInfoVC.h"
#import "MasterCollectionVC.h"
#import "VmCollectionVC.h"
#import "StorageCollectionVC.h"
#import "HostNetworkCollectionVC.h"
#import "HostNicCollectionVC.h"

@implementation HostContainerVC

-(void)refresh{
    self.pathLabel.text = [NSString stringWithFormat:@"%@ → %@", [RemoteObject getCurrentDatacenterVO].name, self.hostVO.resourcePoolName];
    self.titleLabel.text = self.hostVO.hostName;
    self.ipLabel.text = self.hostVO.ip;
    self.statusLabel.text = [self.hostVO state_text];
    self.statusLabel.textColor = [self.hostVO state_color];
        
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:5];
    
    HostDetailInfoVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HostDetailInfoVC"];
    detailVC.hostVO = self.hostVO;
    [pages addObject:detailVC];
    
    
    UIViewController *performVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HostDetailPerformanceVC"];
    [pages addObject:performVC];
    
    VmCollectionVC *hostVmCollectionVC = [[UIStoryboard storyboardWithName:@"VM" bundle:nil] instantiateViewControllerWithIdentifier:@"VmCollectionVC"];
    hostVmCollectionVC.hostVO = self.hostVO;
    [pages addObject:hostVmCollectionVC];
    
    StorageCollectionVC *hostStorageCollectionVC = [[UIStoryboard storyboardWithName:@"Storage" bundle:nil] instantiateViewControllerWithIdentifier:@"StorageCollectionVC"];
    hostStorageCollectionVC.hostVO = self.hostVO;
    [pages addObject:hostStorageCollectionVC];
    
    HostNetworkCollectionVC *hostNetworkCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HostNetworkCollectionVC"];
    hostNetworkCollectionVC.hostVO = self.hostVO;
    [pages addObject:hostNetworkCollectionVC];
    
    HostNicCollectionVC *hostNicCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HostNicCollectionVC"];
    hostNicCollectionVC.hostVO = self.hostVO;
    [pages addObject:hostNicCollectionVC];
    
    self.pages = pages;
    
    [super refresh];
}

@end
