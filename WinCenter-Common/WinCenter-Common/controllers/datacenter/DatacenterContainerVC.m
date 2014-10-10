//
//  DatacenterContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterContainerVC.h"
#import "MasterCollectionVC.h"
#import "NetworkContainerVC.h"
#import "DatacenterDetailCollectionVC.h"

@implementation DatacenterContainerVC

- (void)viewDidLoad{
    [super viewDidLoad];
    NSString *theme = [[NSUserDefaults standardUserDefaults] stringForKey:@"Storyboard_Theme"];
    if((theme!=nil) && [theme isEqualToString:@"Theme"]){
        self.switchPageVC_withoutAnimation = YES;
    }
    
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

- (void)didFinished:(DatacenterTableVC *)controller{
    if(self.popoverVC){
        [self.popoverVC dismissPopoverAnimated:YES];
        [self.infoVC refresh];
        [self refresh];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toSelect"]){
        self.popoverVC = [(UIStoryboardPopoverSegue*)segue popoverController];
        UINavigationController *nav = segue.destinationViewController;
        DatacenterTableVC *vc = [[nav viewControllers] firstObject];
        vc.delegate = self;
        
    }else if([segue.identifier isEqualToString:@"toInfoVC"]){
        self.infoVC = segue.destinationViewController;
    }else if([segue.identifier isEqualToString:@"toMenuVC"]){
        self.menuVC = segue.destinationViewController;
    }
    
}

- (void)refresh{
    self.titleLabel.text = [RemoteObject getCurrentDatacenterVO].name;
    
    if(false){
        NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:1];
        UINavigationController *homeNav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailInfoVCNav"];
        [pages addObject:homeNav];
        
        for(int i=Page_Pool; i<=Page_Business; i++){
            UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVCNav"];
            DatacenterDetailCollectionVC *collectionVC = [[nav childViewControllers] firstObject];
            collectionVC.pageType = i;
            collectionVC.isMore = YES;
            [pages addObject:nav];
        }
        
        self.pages = pages;
        
    }else{
        self.pages = @[
            [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVC"],
            [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVC"],
            [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVC"],
            [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVC"],
            [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterDetailCollectionVC"],
            [[UIStoryboard storyboardWithName:@"Network"] instantiateInitialViewController]
        ];
        
        ((DatacenterDetailCollectionVC*)self.pages[0]).pageType = Page_Pool;
        ((DatacenterDetailCollectionVC*)self.pages[1]).pageType = Page_Host;
        ((DatacenterDetailCollectionVC*)self.pages[2]).pageType = Page_Storage;
        ((DatacenterDetailCollectionVC*)self.pages[3]).pageType = Page_VM;
        ((DatacenterDetailCollectionVC*)self.pages[4]).pageType = Page_Business;
    }
    
    [super refresh];
}

- (void)setPageButtonSelected:(NSInteger)index{
    [self.infoVC switchButtonSelected:self.showIndex];
}

-(IBAction)showOptionsVC:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Setting"]  instantiateInitialViewController];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(IBAction)showWarningInfoVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Warning"] instantiateInitialViewController];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task"] instantiateInitialViewController];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonWarning];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
@end
