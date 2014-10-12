//
//  DatacenterDashboardVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-11.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterDashboardVC.h"
#import "DatacenterDetailCollectionVC.h"

@interface DatacenterDashboardVC ()

@end

@implementation DatacenterDashboardVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.menuVC.tabBarVC = self.tabBarVC;
    
    [DatacenterVO getDatacenterListAsync:^(NSArray *allRemote, NSError *error) {
        if(allRemote.count>0){
            [RemoteObject setCurrentDatacenterVO:[allRemote firstObject]];
            [self refresh];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"尚没有配置任何数据中心，请联系虚拟化平台管理员！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMenuVC"]){
        self.menuVC = segue.destinationViewController;
    }else if([segue.identifier isEqualToString:@"toTabBarVC"]){
        self.tabBarVC = segue.destinationViewController;
    }
    
}

- (void)refresh{
    self.title = [RemoteObject getCurrentDatacenterVO].name;
    
    UINavigationController *nav;
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailInfoVCNav"];
    [self.tabBarVC addChildViewController:nav];
    
    
    DatacenterDetailCollectionVC *collectionVC;
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterPoolCollectionVCNav"];
    collectionVC = [[nav childViewControllers] firstObject];
    collectionVC.pageType = Page_Pool;
    collectionVC.isMore = YES;
    [self.tabBarVC addChildViewController:nav];
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterHostCollectionVCNav"];
    collectionVC = [[nav childViewControllers] firstObject];
    collectionVC.pageType = Page_Host;
    collectionVC.isMore = YES;
    [self.tabBarVC addChildViewController:nav];
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterVmCollectionVCNav"];
    collectionVC = [[nav childViewControllers] firstObject];
    collectionVC.pageType = Page_VM;
    collectionVC.isMore = YES;
    [self.tabBarVC addChildViewController:nav];
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterStorageCollectionVCNav"];
    collectionVC = [[nav childViewControllers] firstObject];
    collectionVC.pageType = Page_Storage;
    collectionVC.isMore = YES;
    [self.tabBarVC addChildViewController:nav];
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterBusinessCollectionVCNav"];
    collectionVC = [[nav childViewControllers] firstObject];
    collectionVC.pageType = Page_Business;
    collectionVC.isMore = YES;
    [self.tabBarVC addChildViewController:nav];
    
    //网络
    [self.tabBarVC addChildViewController:[[UINavigationController alloc] initWithRootViewController:[UIViewController new]]];
    
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterTableVCNav"];
    [self.tabBarVC addChildViewController:nav];
    
    nav = [[UIStoryboard storyboardWithName:@"Setting"] instantiateViewControllerWithIdentifier:@"PopOptionsVCNav"];
    [self.tabBarVC addChildViewController:nav];
    
    
    [self.tabBarVC setSelectedIndex:0];
}

@end
