//
//  BusinessDetailVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-20.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "BusinessDetailInfoVC.h"
#import "BusinessVmCollectionVC.h"
#import "BusinessVmCollectionCell.h"
#import "VmContainerVC.h"

@interface BusinessDetailInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *managerId;
@property (weak, nonatomic) IBOutlet UILabel *platform;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *createUser;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation BusinessDetailInfoVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toBusinessVm"]){
        BusinessVmCollectionVC *vmCollectionVC = segue.destinationViewController;
        vmCollectionVC.businessVO = self.businessVO;
    }
}

- (void)viewDidLayoutSubviews{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeMake(320, 800);
    }
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [self.businessVO getBusinessVOAsync:^(id object, NSError *error) {
        self.businessVO = object;
        [self refresh];
        
    }];
}

- (void)refresh{
    self.managerId.text = self.businessVO.managerId;
    self.platform.text = self.businessVO.sysSrc;
    self.createTime.text = [self.businessVO.createTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
    self.createUser.text = self.businessVO.createUser;
    self.desc.text = self.businessVO.desc;
}


@end
