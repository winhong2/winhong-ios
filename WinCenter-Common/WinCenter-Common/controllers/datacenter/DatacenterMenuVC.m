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
    self.tableView.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
}

- (IBAction)switchTabBar:(id)sender {
    [self.tabBarVC setSelectedIndex:((UIButton*)sender).tag];
}


@end
