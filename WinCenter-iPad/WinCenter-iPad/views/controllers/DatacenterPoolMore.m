//
//  DatacenterPoolMore.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterPoolMore.h"
#import "DatacenterPoolCollectionVC.h"

@implementation DatacenterPoolMore

-(void)refresh{
    self.titleLabel.text = [NSString stringWithFormat:@"%@下的资源池列表", [RemoteObject getCurrentDatacenterVO].name];
    
    DatacenterPoolCollectionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterPoolCollectionVC"];
    vc.isMore = true;
    self.pages = @[vc];
    
    [super refresh];
}

@end
