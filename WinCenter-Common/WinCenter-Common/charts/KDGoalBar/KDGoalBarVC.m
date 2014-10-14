//
//  RootViewController.m
//  Test_Pro
//
//  Created by HuHongbing  on 12/18/12.
//  Copyright (c) huhongbin2000@126.com All rights reserved.
//

#import "KDGoalBarVC.h"
#import "KDGoalBar.h"

@interface KDGoalBarVC ()

@end

@implementation KDGoalBarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor grayColor];
    KDGoalBar*firstGoalBar = [[KDGoalBar alloc]initWithFrame:CGRectMake((320-177)/2., 100, 177, 177)];
    [firstGoalBar setPercent:75 animated:NO];
    [self.view addSubview:firstGoalBar];
}


@end
