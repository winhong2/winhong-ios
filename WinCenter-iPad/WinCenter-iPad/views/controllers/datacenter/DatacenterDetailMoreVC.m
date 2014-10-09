//
//  DatacenterPoolMore.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterDetailMoreVC.h"
#import "DatacenterDetailCollectionVC.h"

@implementation DatacenterDetailMoreVC

-(void)refresh{
    switch (self.pageType) {
        case Page_Pool:{
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的资源池列表", [RemoteObject getCurrentDatacenterVO].name];
            if(self.titleItem){
                self.titleItem.title = [NSString stringWithFormat:@"%@下的资源池列表", [RemoteObject getCurrentDatacenterVO].name];
            }
            break;
        }
        case Page_Host:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的物理机列表", self.poolVO.resourcePoolName];
            if(self.titleItem){
                self.titleItem.title = [NSString stringWithFormat:@"%@下的物理机列表", self.poolVO.resourcePoolName];
            }
            break;
        }
        case Page_Storage:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的共享存储列表", self.poolVO.resourcePoolName];
            if(self.titleItem){
                self.titleItem.title = [NSString stringWithFormat:@"%@下的共享存储列表", self.poolVO.resourcePoolName];
            }
            break;
        }
        case Page_VM:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的虚拟机列表", self.poolVO.resourcePoolName];
            if(self.titleItem){
                self.titleItem.title = [NSString stringWithFormat:@"%@下的虚拟机列表", self.poolVO.resourcePoolName];
            }
            break;
        }
        case Page_Business:{
            self.pathLabel.text = [NSString stringWithFormat:@"%@", [RemoteObject getCurrentDatacenterVO].name];
            self.titleLabel.text = [NSString stringWithFormat:@"%@下的业务系统列表", self.poolVO.resourcePoolName];
            if(self.titleItem){
                self.titleItem.title = [NSString stringWithFormat:@"%@下的业务系统列表", self.poolVO.resourcePoolName];
            }
            break;
        }
        default:
            break;
    }
    
    
    
    DatacenterDetailCollectionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVC"];
    vc.isMore = true;
    vc.poolVO = self.poolVO;
    vc.pageType = self.pageType;
    self.pages = @[vc];
    
    [super refresh];
}

@end
