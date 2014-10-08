//
//  BusinessContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "BusinessContainerVC.h"
#import "BusinessDetailInfoVC.h"

@implementation BusinessContainerVC

-(void)refresh{
    self.pathLabel.text = [RemoteObject getCurrentDatacenterVO].name;
    self.titleLabel.text = self.businessVO.name;
    
    BusinessDetailInfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BusinessDetailInfoVC"];
    vc.businessVO = self.businessVO;
    self.pages = @[vc];
    
    [super refresh];
}

@end
