//
//  BusinessDetailVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-20.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "BusinessDetailInfoVC.h"
#import "VmCollectionCell.h"
#import "VmContainerVC.h"

@interface BusinessDetailInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *managerId;
@property (weak, nonatomic) IBOutlet UILabel *platform;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *createUser;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation BusinessDetailInfoVC

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
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [self.businessVO getBusinessVOAsync:^(id object, NSError *error) {
        self.businessVO = object;
        self.dataList = self.businessVO.wceBusVms;
        [self refresh];
        
    }];
}

- (void)refresh{
    self.managerId.text = self.businessVO.managerId;
    self.platform.text = self.businessVO.sysSrc;
    self.createTime.text = [self.businessVO.createTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
    self.createUser.text = self.businessVO.createUser;
    self.desc.text = self.businessVO.desc;
    
    self.collectionHeader.text = [NSString stringWithFormat:@"虚拟机(%li)", self.dataList.count];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VmCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VmCollectionCell" forIndexPath:indexPath];
    
    BusinessVmVO *vmvo = (BusinessVmVO*)self.dataList[indexPath.row];
    cell.name.text = vmvo.name;
    cell.startOrder.text = [NSString stringWithFormat:@"%d", vmvo.startOrder];
    cell.delayInterval.text = [NSString stringWithFormat:@"%d", vmvo.delayInterval];
    cell.state.text = [vmvo state_text];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *root = [[UIStoryboard storyboardWithName:@"VM" bundle:nil] instantiateInitialViewController];
    VmContainerVC *vc;
    if([root isKindOfClass:[VmContainerVC class]]){
        vc = (VmContainerVC*) root;
    }else{
        vc = [[root childViewControllers] firstObject];
    }
    BusinessVmVO *businessVmvo = (BusinessVmVO*)self.dataList[indexPath.row];
    VmVO *vmvo = [[VmVO alloc] init];
    vmvo.vmId = businessVmvo.vmId;
    vmvo.name = businessVmvo.name;
    vc.vmVO = vmvo;
    [self presentViewController:root animated:YES completion:nil];
}


@end
