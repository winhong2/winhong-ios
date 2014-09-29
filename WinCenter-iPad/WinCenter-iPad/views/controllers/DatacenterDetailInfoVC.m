//
//  DatacenterDetailInfoVC.m
//  wincenterDemo01
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "DatacenterDetailInfoVC.h"
#import "MasterContainerVC.h"

@interface DatacenterDetailInfoVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property DatacenterStatWinserver *datacenterStatWinserver;

@end

@implementation DatacenterDetailInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews{
    self.scrollView.contentSize = CGSizeMake(275, 420);
}
- (void)viewDidLoad{
    [self refresh];
}
- (void)refresh{
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getDatacenterStatUrl, self.datacenterVO.id]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.datacenterStatWinserver = [[DatacenterStatVO alloc] initWithJSONData:jsonResponse.rawBody].winserver;
        [self performSelectorOnMainThread:@selector(refreshMainInfo) withObject:nil waitUntilDone:NO];
        
        [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
            [simpleRequest setUrl:[NSString stringWithFormat:getBusinessListUrl_all, self.datacenterVO.id]];
        }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
            self.datacenterStatWinserver.appNumber = [[BusinessListResult alloc] initWithJSONData:jsonResponse.rawBody].recordTotal;
            [self performSelectorOnMainThread:@selector(refreshMainInfo) withObject:nil waitUntilDone:NO];
        }];
    }];
    
}

- (void)refreshMainInfo{
    [self switchButtonSelected:0];
    
    self.poolCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.resPoolNumber];
    self.hostCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.hostNubmer];
    self.vmCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.vmNumber];
    self.businessCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.appNumber];
    
    self.cpuUnitCount.text = [NSString stringWithFormat:@"%d核",self.datacenterStatWinserver.physicalCpuNumber];
//    self.cpuUsedInfo.text = [NSString stringWithFormat:@"已用%@核  还剩%@核",self.datacenterVO.cpuUnitUsedCount,self.datacenterVO.cpuUnitUnusedCount];
//    self.cpuProgress.progress = self.datacenterVO.cpuRatio;
    
    self.memerySize.text = [NSString stringWithFormat:@"%.2fG",self.datacenterStatWinserver.memorySize/1024.0];
//    self.memeryUsedInfo.text = [NSString stringWithFormat:@"已用%@G  还剩%@G",self.datacenterVO.memeryUsedSize,self.datacenterVO.memeryUnusedSize];
//    self.memoryProgress.progress = self.datacenterVO.memoryRatio;
    
    self.storageSize.text = [NSString stringWithFormat:@"%.2fT",self.datacenterStatWinserver.storageSize/1024.0];
//    self.storageUsedInfo.text = [NSString stringWithFormat:@"已用%@T  还剩%@T",self.datacenterVO.storageUsedSize,self.datacenterVO.storageUnusedSize];
//    self.storageProgress.progress = self.datacenterVO.storageRatio;
    
//    self.networkIpCount.text = [NSString stringWithFormat:@"%@个",self.datacenterVO.networkIpCount];
//    self.networkIpUsedInfo.text = [NSString stringWithFormat:@"已用%@个  还剩%@个",self.datacenterVO.networkIpUsedCount,self.datacenterVO.networkIpUnusedCount];
//    self.networkProgress.progress = self.datacenterVO.networkRatio;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchPageVC:(id)sender {
    [self switchButtonSelected:((UIView*)sender).tag];
    
    [((MasterContainerVC *)self.parentViewController) switchPageVC:((UIView*)sender).tag];
    
}
- (void)switchButtonSelected:(NSInteger)index{
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.button3.selected = NO;
    self.button4.selected = NO;
    self.button5.selected = NO;
    self.button6.selected = NO;
    
    switch(index){
        case 0: self.button1.selected = YES; break;
        case 1: self.button2.selected = YES; break;
        case 2: self.button3.selected = YES; break;
        case 3: self.button4.selected = YES; break;
        case 4: self.button5.selected = YES; break;
        case 5: self.button6.selected = YES; break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
