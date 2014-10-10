//
//  HostDetailBaseinfoVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-15.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HostDetailInfoVC.h"

@interface HostDetailInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *virtualMachineNum;
@property (weak, nonatomic) IBOutlet UILabel *networkNum;
@property (weak, nonatomic) IBOutlet UILabel *startRunTime;
@property (weak, nonatomic) IBOutlet UILabel *virtualInfo;
@property (weak, nonatomic) IBOutlet UILabel *virtualDate;
@property (weak, nonatomic) IBOutlet UILabel *cpuSpeed;
@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UILabel *vendor;
@property (weak, nonatomic) IBOutlet UILabel *cpuSlots;
@property (weak, nonatomic) IBOutlet UILabel *cpu;

@property (weak, nonatomic) IBOutlet UILabel *cpuUnitCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuUnitUsedCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuUnitUnusedCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuRatio;
@property (weak, nonatomic) IBOutlet UIView *cpuChartGroup;


@property (weak, nonatomic) IBOutlet UILabel *memorySize;
@property (weak, nonatomic) IBOutlet UILabel *memoryUsedSize;
@property (weak, nonatomic) IBOutlet UILabel *memoryUnusedSize;
@property (weak, nonatomic) IBOutlet UILabel *memoryRatio;
@property (weak, nonatomic) IBOutlet UIView *memoryChartGroup;

@property (weak, nonatomic) IBOutlet UILabel *storageSize;
@property (weak, nonatomic) IBOutlet UILabel *storageUsedSize;
@property (weak, nonatomic) IBOutlet UILabel *storageUnusedSize;
@property (weak, nonatomic) IBOutlet UILabel *storageRatio;
@property (weak, nonatomic) IBOutlet UIView *storageChartGroup;


@property (weak, nonatomic) IBOutlet UIImageView *osType;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation HostDetailInfoVC

- (void)viewDidLayoutSubviews{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeMake(320, 1450);
    }
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [self.hostVO getHostVOAsync:^(id object, NSError *error) {
        self.hostVO = object;
        [self refreshMainInfo];
    }];
    
    [self.hostVO getHostStatVOAsync:^(id object, NSError *error) {
        self.statVO = object;
        [self refreshStatInfo];
    }];
}

- (void)refreshMainInfo{
    self.virtualMachineNum.text = [NSString stringWithFormat:@"%d", self.hostVO.virtualMachineNum];
    //self.activeMachineNum.text = [NSString stringWithFormat:@"%d", 0];
    self.networkNum.text = [NSString stringWithFormat:@"%d", self.hostVO.networkNum];
    self.startRunTime.text = [NSString stringWithFormat:@"%d", self.hostVO.startRunTime];
    self.virtualInfo.text = [NSString stringWithFormat:@"%@ %@", self.hostVO.virtualSoftware, self.hostVO.virtualVersion];
    self.virtualDate.text = [NSString stringWithFormat:@"%@", self.hostVO.versionDate];
    self.cpuSpeed.text = [NSString stringWithFormat:@"%dMHz", self.hostVO.cpuSpeed];
    self.model.text = [NSString stringWithFormat:@"%@", self.hostVO.model];
    self.vendor.text = [NSString stringWithFormat:@"%@", self.hostVO.vendor];
    self.cpuSlots.text = [NSString stringWithFormat:@"%d颗", self.hostVO.cpuSlots];
    self.cpu.text = [NSString stringWithFormat:@"%d个", self.hostVO.cpu];
    
}
- (void)refreshStatInfo{
    self.cpuUnitCount.text = [NSString stringWithFormat:@"%.2fGHz", self.statVO.cpuTotal/1000.0];
    self.cpuUnitUsedCount.text = [NSString stringWithFormat:@"%.2fGHz", self.statVO.cpuUsed/1000.0];
    self.cpuUnitUnusedCount.text = [NSString stringWithFormat:@"%.2fGHz", (self.statVO.cpuTotal-self.statVO.cpuUsed)/1000.0];
    self.cpuRatio.text = [NSString stringWithFormat:@"%.0f%%", self.statVO.cpuUsedPer*100];
    
    self.memorySize.text = [NSString stringWithFormat:@"%.2fGB", self.statVO.totalMem/1024.0];
    self.memoryUsedSize.text = [NSString stringWithFormat:@"%.2fGB", (self.statVO.totalMem-self.statVO.freeMem)/1024.0];
    self.memoryUnusedSize.text = [NSString stringWithFormat:@"%.2fGB", self.statVO.freeMem/1024.0];
    self.memoryRatio.text = [NSString stringWithFormat:@"%.0f%%", (self.statVO.totalMem-self.statVO.freeMem)/self.statVO.totalMem*100];
    
    self.storageSize.text = [NSString stringWithFormat:@"%.2fTB", self.statVO.totalStorage/1024.0];
    self.storageUsedSize.text = [NSString stringWithFormat:@"%.2fTB", self.statVO.usedStorage/1024.0];
    self.storageUnusedSize.text = [NSString stringWithFormat:@"%.2fTB", (self.statVO.totalStorage-self.statVO.usedStorage)/1024.0];
    self.storageRatio.text = [NSString stringWithFormat:@"%.0f%%", self.statVO.usedStorage/self.statVO.totalStorage*100];
    
    //圈图
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:self.cpuChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.statVO cpuRatio]] andClockwise:YES andShadow:YES];
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.labelColor = [UIColor clearColor];
    [circleChart setStrokeColor:[self.statVO cpuRatioColor]];
    [circleChart strokeChart];
    [self.cpuChartGroup addSubview:circleChart];
    
    PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:self.memoryChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.statVO memoryRatio]] andClockwise:YES andShadow:YES];
    circleChart2.backgroundColor = [UIColor clearColor];
    circleChart2.labelColor = [UIColor clearColor];
    [circleChart2 setStrokeColor:[self.statVO memoryRatioColor]];
    [circleChart2 strokeChart];
    [self.memoryChartGroup addSubview:circleChart2];
    
    PNCircleChart * circleChart3 = [[PNCircleChart alloc] initWithFrame:self.storageChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.statVO storageRatio]] andClockwise:YES andShadow:YES];
    circleChart3.backgroundColor = [UIColor clearColor];
    circleChart3.labelColor = [UIColor clearColor];
    [circleChart3 setStrokeColor:[self.statVO storageRatioColor]];
    [circleChart3 strokeChart];
    [self.storageChartGroup addSubview:circleChart3];
}


@end