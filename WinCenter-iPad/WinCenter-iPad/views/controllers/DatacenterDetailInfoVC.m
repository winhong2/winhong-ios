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

- (void)viewDidLayoutSubviews{
    self.scrollView.contentSize = CGSizeMake(275, 420);
}

- (void)refresh{
    [self switchButtonSelected:0];
    
    [[RemoteObject getCurrentDatacenterVO] getDatacenterStatWinserverVOAsync:^(id object, NSError *error) {
        self.datacenterStatWinserver = object;
        [self refreshMainInfo];
        
        [[RemoteObject getCurrentDatacenterVO] getBusinessListAsync:^(NSArray *allRemote, NSError *error) {
            self.datacenterStatWinserver.appNumber = (int) allRemote.count;
            [self refreshMainInfo2];
        }];
        
        [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
            for(PoolVO *poolVO in allRemote){
                [poolVO getPoolVOAsync:^(id object, NSError *error) {
                    self.datacenterStatWinserver.totalCpu += ((PoolVO *)object).totalCpu;
                    self.datacenterStatWinserver.totalMemory += ((PoolVO *)object).totalMemory;
                    self.datacenterStatWinserver.totalStorage += ((PoolVO *)object).totalStorage;
                    self.datacenterStatWinserver.availCpu += ((PoolVO *)object).availCpu;
                    self.datacenterStatWinserver.availMemory += ((PoolVO *)object).availMemory;
                    self.datacenterStatWinserver.availStorage += ((PoolVO *)object).availStorage;
                    
                    [self refreshMainInfo3];
                }];
            }
        }];
    }];
}
- (void)refreshMainInfo2{
    self.businessCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.appNumber];

}
- (void)refreshMainInfo{
    self.poolCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.resPoolNumber];
    self.hostCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.hostNubmer];
    self.vmCount.text = [NSString stringWithFormat:@"%d",self.datacenterStatWinserver.vmNumber];
}

- (void)refreshMainInfo3{
    self.cpuUnitCount.text = [NSString stringWithFormat:@"%.2fGHz",self.datacenterStatWinserver.totalCpu/1000.0];
    self.cpuUsedInfo.text = [NSString stringWithFormat:@"已用%.2fGHz  还剩%.2fGHz",(self.datacenterStatWinserver.totalCpu-self.datacenterStatWinserver.availCpu)/1000.0,self.datacenterStatWinserver.availCpu/1000.0];
    self.cpuProgress.progress = self.datacenterStatWinserver.cpuRatio/100.0;
    self.cpuProgress.tintColor = [self.datacenterStatWinserver cpuRatioColor];
    
    self.memerySize.text = [NSString stringWithFormat:@"%.2fG",self.datacenterStatWinserver.totalMemory/1024.0];
    self.memeryUsedInfo.text = [NSString stringWithFormat:@"已用%.2fG  还剩%.2fG",(self.datacenterStatWinserver.totalMemory-self.datacenterStatWinserver.availMemory)/1024.0,self.datacenterStatWinserver.availMemory/1024.0];
    self.memoryProgress.progress = self.datacenterStatWinserver.memoryRatio/100.0;
    self.memoryProgress.tintColor = [self.datacenterStatWinserver memoryRatioColor];
    
    self.storageSize.text = [NSString stringWithFormat:@"%.2fT",self.datacenterStatWinserver.totalStorage/1024.0];
    self.storageUsedInfo.text = [NSString stringWithFormat:@"已用%.2fT  还剩%.2fT",(self.datacenterStatWinserver.totalStorage-self.datacenterStatWinserver.availStorage)/1024.0,self.datacenterStatWinserver.availStorage/1024.0];
    self.storageProgress.progress = self.datacenterStatWinserver.storageRatio/100.0;
    self.storageProgress.tintColor = [self.datacenterStatWinserver storageRatioColor];
    
//    self.networkIpCount.text = [NSString stringWithFormat:@"%@个",self.datacenterVO.networkIpCount];
//    self.networkIpUsedInfo.text = [NSString stringWithFormat:@"已用%@个  还剩%@个",self.datacenterVO.networkIpUsedCount,self.datacenterVO.networkIpUnusedCount];
//    self.networkProgress.progress = self.datacenterVO.networkRatio;
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

@end
