//
//  BusinessDetailVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-20.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "BusinessDetailInfoVC.h"
#import "VmCollectionCell.h"
#import "MasterContainerVC.h"

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
    // Do any additional setup after loading the view.
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getBusinessVM, self.datacenterVO.id, self.baseObject.busId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.baseObject = [[BusinessVO alloc] initWithJSONData:jsonResponse.rawBody];
        self.dataList = self.baseObject.wceBusVms;
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }];
}

- (void)refresh{
    self.managerId.text = self.baseObject.managerId;
    self.platform.text = self.baseObject.sysSrc;
    self.createTime.text = [self.baseObject.createTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
    self.createUser.text = self.baseObject.createUser;
    self.desc.text = self.baseObject.desc;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MasterContainerVC *vc = segue.destinationViewController;
    vc.datacenterVO = self.datacenterVO;
    NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
    BusinessVmVO *businessVmvo = (BusinessVmVO*)self.dataList[indexPath.row];
    VmVO *vmvo = [[VmVO alloc] init];
    vmvo.vmId = businessVmvo.vmId;
    vmvo.name = businessVmvo.name;
    vc.baseObject = vmvo;
    vc.pageType = MasterPageType_VM;
}


@end
