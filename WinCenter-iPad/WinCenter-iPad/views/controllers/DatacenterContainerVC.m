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

@implementation DatacenterContainerVC

- (void)viewDidLoad{
    [super viewDidLoad];
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
    }
    
}

- (void)refresh{
    self.titleLabel.text = [RemoteObject getCurrentDatacenterVO].name;
    
    self.pages = @[
        [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterPoolCollectionVC"],
        [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterHostCollectionVC"],
        [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterStorageCollectionVC"],
        [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterVmCollectionVC"],
        [self.storyboard instantiateViewControllerWithIdentifier:@"DatacenterBusinessCollectionVC"],
        [self.storyboard instantiateViewControllerWithIdentifier:@"NetworkContainerVC"]
    ];
    
    [super refresh];
}

- (void)setPageButtonSelected:(NSInteger)index{
    [self.infoVC switchButtonSelected:self.showIndex];
}

-(IBAction)showOptionsVC:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil]  instantiateViewControllerWithIdentifier:@"OptionsVCNav"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(IBAction)showWarningInfoVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Datacenter" bundle:nil] instantiateViewControllerWithIdentifier:@"WarningInfoVCNav"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonWarning];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Datacenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ControlRecordVCNav"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIButton *button = (UIButton*)sender;
    self.popover.passthroughViews=@[self.buttonTask];
    [self.popover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
@end
