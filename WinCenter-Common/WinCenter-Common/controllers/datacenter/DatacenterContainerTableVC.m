//
//  DatacenterContainerTableVC.m
//  WinCenter-iPhone
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterContainerTableVC.h"
#import "DatacenterDetailCollectionVC.h"
#import "MSCalendarViewController.h"

@interface DatacenterContainerTableVC ()

@end

@implementation DatacenterContainerTableVC

- (void)viewWillDisappear:(BOOL)animated
{
    [self showNavBarAnimated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // This enables the user to scroll down the navbar by tapping the status bar.
    [self showNavbar];
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self followScrollView:self.tableView];
    
    [DatacenterVO getDatacenterListAsync:^(NSArray *allRemote, NSError *error) {
        if(allRemote.count>0){
            [RemoteObject setCurrentDatacenterVO:[allRemote firstObject]];
            [self.infoVC refresh];
            [self refresh];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"尚没有配置任何数据中心，请联系虚拟化平台管理员！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toSelect"]){
        UINavigationController *nav = segue.destinationViewController;
        DatacenterTableVC *vc = [[nav viewControllers] firstObject];
        vc.delegate = self;
    }else if([segue.identifier isEqualToString:@"toInfoVC"]){
        self.infoVC = segue.destinationViewController;
    }else if([segue.identifier isEqualToString:@"toPool"]){
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).pageType = Page_Pool;
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).title = @"资源池列表";
    }else if([segue.identifier isEqualToString:@"toHost"]){
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).pageType = Page_Host;
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).title = @"物理机列表";
    }else if([segue.identifier isEqualToString:@"toStorage"]){
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).pageType = Page_Storage;
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).title = @"存储池列表";
    }else if([segue.identifier isEqualToString:@"toVm"]){
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).pageType = Page_VM;
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).title = @"虚拟机列表";
    }else if([segue.identifier isEqualToString:@"toBusiness"]){
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).pageType = Page_Business;
        ((DatacenterDetailCollectionVC*)segue.destinationViewController).title = @"业务系统列表";
    }
}

- (void)refresh{
    self.title = [RemoteObject getCurrentDatacenterVO].name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2){
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Charts"] instantiateViewControllerWithIdentifier:@"ChartTableVC"] animated:YES];
    }
    else if(indexPath.section==3){
        if(indexPath.row==0){
            [self showWarningInfoVC:nil];
        }else if(indexPath.row==1){
            [self showControlRecordVC:nil];
        }
    }else if(indexPath.section==4){
        [self.navigationController pushViewController:[MSCalendarViewController new] animated:YES];
    }
}

- (void)didFinished:(DatacenterTableVC *)controller{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    if(self.infoVC){
        [self.infoVC refresh];
    }
    [self refresh];
}
- (IBAction)showSelectForm:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterTableVCNav"];
    DatacenterTableVC *tableVC = [[vc childViewControllers] firstObject];
    tableVC.delegate = self;
    [self mz_presentFormSheetWithViewController:vc animated:YES completionHandler:nil];
}

-(IBAction)showOptionsVC:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Setting"]  instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(IBAction)showWarningInfoVC:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Warning"] instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)showControlRecordVC:(id)sender{
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task"] instantiateInitialViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
