//
//  DatacenterDashboardMenuVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterMenuVC.h"
#import "MasterContainerVC.h"

@interface DatacenterMenuVC ()

@end

@implementation DatacenterMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)switchTabBar:(id)sender {
    [((MasterContainerVC *)self.parentViewController) switchPageVC:((UIButton*)sender).tag];
}


@end
