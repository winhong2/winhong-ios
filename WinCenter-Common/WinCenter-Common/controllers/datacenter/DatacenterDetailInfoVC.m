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

@property (weak, nonatomic) IBOutlet UIView *cpuChartGroup;
@property (weak, nonatomic) IBOutlet UIView *memoryChartGroup;
@property (weak, nonatomic) IBOutlet UIView *storageChartGroup;
//@property (weak, nonatomic) IBOutlet UIView *ipChartGroup;

@property DatacenterStatWinserver *datacenterStatWinserver;

@end

@implementation DatacenterDetailInfoVC

- (void)viewDidLayoutSubviews{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeMake(275, 420);
    }
}

- (void)viewDidLoad{
    [self refresh];
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
    self.cpuUsedCount.text = [NSString stringWithFormat:@"%.2fGHz",(self.datacenterStatWinserver.totalCpu-self.datacenterStatWinserver.availCpu)/1000.0];
    self.cpuUnitUnusedCount.text = [NSString stringWithFormat:@"%.2fGHz",self.datacenterStatWinserver.availCpu/1000.0];
//    self.cpuUsedInfo.text = [NSString stringWithFormat:@"已用%.2fGHz  还剩%.2fGHz",(self.datacenterStatWinserver.totalCpu-self.datacenterStatWinserver.availCpu)/1000.0,self.datacenterStatWinserver.availCpu/1000.0];
//    self.cpuProgress.progress = self.datacenterStatWinserver.cpuRatio/100.0;
//    self.cpuProgress.tintColor = [self.datacenterStatWinserver cpuRatioColor];
//    
    self.memerySize.text = [NSString stringWithFormat:@"%.2fG",self.datacenterStatWinserver.totalMemory/1024.0];
    self.memeryUsedSize.text = [NSString stringWithFormat:@"%.2fG",(self.datacenterStatWinserver.totalMemory-self.datacenterStatWinserver.availMemory)/1024.0];
    self.memoryUnusedSize.text = [NSString stringWithFormat:@"%.2fG",self.datacenterStatWinserver.availMemory/1024.0];
//    self.memeryUsedInfo.text = [NSString stringWithFormat:@"已用%.2fG  还剩%.2fG",(self.datacenterStatWinserver.totalMemory-self.datacenterStatWinserver.availMemory)/1024.0,self.datacenterStatWinserver.availMemory/1024.0];
//    self.memoryProgress.progress = self.datacenterStatWinserver.memoryRatio/100.0;
//    self.memoryProgress.tintColor = [self.datacenterStatWinserver memoryRatioColor];
//    
    self.storageSize.text = [NSString stringWithFormat:@"%.2fT",self.datacenterStatWinserver.totalStorage/1024.0];
    self.storageUsedSize.text = [NSString stringWithFormat:@"%.2fT",(self.datacenterStatWinserver.totalStorage-self.datacenterStatWinserver.availStorage)/1024.0];
    self.storageUnusedSize.text = [NSString stringWithFormat:@"%.2fT",self.datacenterStatWinserver.availStorage/1024.0];
//    self.storageUsedInfo.text = [NSString stringWithFormat:@"已用%.2fT  还剩%.2fT",(self.datacenterStatWinserver.totalStorage-self.datacenterStatWinserver.availStorage)/1024.0,self.datacenterStatWinserver.availStorage/1024.0];
//    self.storageProgress.progress = self.datacenterStatWinserver.storageRatio/100.0;
//    self.storageProgress.tintColor = [self.datacenterStatWinserver storageRatioColor];
    
//    self.networkIpCount.text = [NSString stringWithFormat:@"%@个",self.datacenterStatWinserver.networkIpCount];
//    self.networkIpUsedInfo.text = [NSString stringWithFormat:@"已用%@个  还剩%@个",self.datacenterStatWinserver.networkIpUsedCount,self.datacenterStatWinserver.networkIpUnusedCount];
//    self.networkProgress.progress = self.datacenterStatWinserver.networkRatio;
    
    //圈图
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:self.cpuChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.datacenterStatWinserver cpuRatio]] andClockwise:YES andShadow:YES];
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.labelColor = [UIColor clearColor];
    circleChart.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
    circleChart.circle.lineCap = kCALineCapSquare;//直角填充
    circleChart.lineWidth = @11.0f;//线宽度
    [circleChart setStrokeColor:[UIColor colorWithRed:71.0/255 green:145.0/255 blue:210.0/255 alpha:1]];//已使用填充颜色
    [circleChart strokeChart];
    [self.cpuChartGroup addSubview:circleChart];
    
    
    PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:self.memoryChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.datacenterStatWinserver memoryRatio]] andClockwise:YES andShadow:YES];
    circleChart2.backgroundColor = [UIColor clearColor];
    circleChart2.labelColor = [UIColor clearColor];
    circleChart2.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
    circleChart2.circle.lineCap = kCALineCapSquare;//直角填充
    circleChart2.lineWidth = @11.0f;//线宽度
    [circleChart2 setStrokeColor:[UIColor colorWithRed:71.0/255 green:145.0/255 blue:210.0/255 alpha:1]];//已使用填充颜色
//    [circleChart2 setStrokeColor:[self.datacenterStatWinserver memoryRatioColor]];
    [circleChart2 strokeChart];
    [self.memoryChartGroup addSubview:circleChart2];
    
    PNCircleChart * circleChart3 = [[PNCircleChart alloc] initWithFrame:self.storageChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.datacenterStatWinserver storageRatio]] andClockwise:YES andShadow:YES];
    circleChart3.backgroundColor = [UIColor clearColor];
    circleChart3.labelColor = [UIColor clearColor];
    circleChart3.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
    circleChart3.circle.lineCap = kCALineCapSquare;//直角填充
    circleChart3.lineWidth = @11.0f;//线宽度
    [circleChart3 setStrokeColor:[UIColor colorWithRed:71.0/255 green:145.0/255 blue:210.0/255 alpha:1]];//已使用填充颜色
//    [circleChart3 setStrokeColor:[self.datacenterStatWinserver storageRatioColor]];
    [circleChart3 strokeChart];
    [self.storageChartGroup addSubview:circleChart3];
    
//    PNCircleChart * circleChart4 = [[PNCircleChart alloc] initWithFrame:self.ipChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.datacenterStatWinserver networkRatio]] andClockwise:YES andShadow:YES];
//    circleChart3.backgroundColor = [UIColor clearColor];
//    circleChart3.labelColor = [UIColor clearColor];
//    [circleChart3 setStrokeColor:[self.datacenterStatWinserver storageRatioColor]];
//    [circleChart3 strokeChart];
//    [self.ipChartGroup addSubview:circleChart4];
    
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
