//
//  PoolDetailBaseinfoVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-21.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PoolDetailInfoVC.h"
#import "PoolVO.h"


@interface PoolDetailInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *hostCount;
@property (weak, nonatomic) IBOutlet UILabel *vmCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuUnitCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuUnitUsedCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuUnitUnusedCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuRatio;

@property (weak, nonatomic) IBOutlet UILabel *memorySize;
@property (weak, nonatomic) IBOutlet UILabel *memoryUsedSize;
@property (weak, nonatomic) IBOutlet UILabel *memoryUnusedSize;
@property (weak, nonatomic) IBOutlet UILabel *memoryRatio;

@property (weak, nonatomic) IBOutlet UILabel *storageSize;
@property (weak, nonatomic) IBOutlet UILabel *storageUsedSize;
@property (weak, nonatomic) IBOutlet UILabel *storageUnusedSize;
@property (weak, nonatomic) IBOutlet UILabel *storageRatio;

@property (weak, nonatomic) IBOutlet UILabel *haErrorHostCount;
@property (weak, nonatomic) IBOutlet UILabel *haSignalNetwork;
@property (weak, nonatomic) IBOutlet UILabel *haSignalPool;

@property (weak, nonatomic) IBOutlet UILabel *elasticModel;
@property (weak, nonatomic) IBOutlet UILabel *cpuLoadBalancing;
@property (weak, nonatomic) IBOutlet UILabel *memeryLoadBalancing;
@property (weak, nonatomic) IBOutlet UILabel *intervalTime;
@property (weak, nonatomic) IBOutlet UILabel *nextCheckTime;
@property (weak, nonatomic) IBOutlet UIView *cpuChartGroup;
@property (weak, nonatomic) IBOutlet UIImageView *cpuChart;
@property (weak, nonatomic) IBOutlet UIView *memoryChartGroup;
@property (weak, nonatomic) IBOutlet UIImageView *memeryChart;
@property (weak, nonatomic) IBOutlet UIView *storageChartGroup;
@property (weak, nonatomic) IBOutlet UIImageView *storageChart;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PoolDetailInfoVC

- (void)viewDidLayoutSubviews{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeMake(320, 1600);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.circleChart strokeChart];
    [self.circleChart2 strokeChart];
    [self.circleChart3 strokeChart];
}

- (void)viewDidLoad
{
    for(UILabel *label in self.allLabels){
        label.text = @"";
    }

    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.poolVO getPoolVOAsync:^(id object, NSError *error) {
        self.poolVO = object;
        [self refreshMainInfo];
    }];
    
    [self.poolVO getPoolElasticAsync:^(id object, NSError *error) {
        self.elasticInfo = object;
        [self refreshElasticInfo];
    }];
    
}

- (void)refreshMainInfo{
    self.name.text = [NSString stringWithFormat:@"%@", self.poolVO.resourcePoolName];
    self.hostCount.text = [NSString stringWithFormat:@"%d", self.poolVO.hostNumber];
    self.vmCount.text = [NSString stringWithFormat:@"%d", self.poolVO.vmNumber];

    self.cpuUnitCount.text = [NSString stringWithFormat:@"%.2fGHz", self.poolVO.totalCpu/1000.0];
    self.cpuUnitUsedCount.text = [NSString stringWithFormat:@"%.2fGHz", (self.poolVO.totalCpu-self.poolVO.availCpu)/1000.0];
    self.cpuUnitUnusedCount.text = [NSString stringWithFormat:@"%.2fGHz", self.poolVO.availCpu/1000.0];
    self.cpuRatio.text = [NSString stringWithFormat:@"%.0f%%", [self.poolVO cpuRatio]];
    
    self.memorySize.text = [NSString stringWithFormat:@"%.2fGB", self.poolVO.totalMemory/1024.0];
    self.memoryUsedSize.text = [NSString stringWithFormat:@"%.2fGB", (self.poolVO.totalMemory-self.poolVO.availMemory)/1024.0];
    self.memoryUnusedSize.text = [NSString stringWithFormat:@"%.2fGB", self.poolVO.availMemory/1024.0];
    self.memoryRatio.text = [NSString stringWithFormat:@"%.0f%%", (self.poolVO.totalMemory-self.poolVO.availMemory)/self.poolVO.totalMemory*100];
    
    self.storageSize.text = [NSString stringWithFormat:@"%.2fGB", self.poolVO.totalStorage/1024.0];
    self.storageUsedSize.text = [NSString stringWithFormat:@"%.2fGB", (self.poolVO.totalStorage - self.poolVO.availStorage)/1024.0];
    self.storageUnusedSize.text = [NSString stringWithFormat:@"%.2fGB", self.poolVO.availStorage/1024.0];
    self.storageRatio.text = [NSString stringWithFormat:@"%.0f%%", (self.poolVO.totalStorage-self.poolVO.availStorage)/self.poolVO.totalStorage*100];
    
    //self.haErrorHostCount.text = self.poolVO.haErrorHostCount;
    //self.haSignalNetwork.text = self.poolVO.haSignalNetwork;
    //self.haSignalPool.text = self.poolVO.haSignalPool;
    //圈图
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.cpuChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.poolVO cpuRatio]] andClockwise:YES andShadow:YES];
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.strokeColor = [UIColor clearColor];
    self.circleChart.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;
    self.circleChart.circle.lineCap = kCALineCapSquare;
    self.circleChart.lineWidth = @11.0f;
    [self.circleChart setStrokeColor:[UIColor colorWithRed:89.0/255 green:203.0/255 blue:92/255 alpha:1]];
    [self.circleChart strokeChart];
    [self.cpuChartGroup addSubview:self.circleChart];
    
    
    self.circleChart2 = [[PNCircleChart alloc] initWithFrame:self.memoryChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.poolVO memoryRatio]] andClockwise:YES andShadow:YES];
    self.circleChart2.backgroundColor = [UIColor clearColor];
    self.circleChart2.strokeColor = [UIColor clearColor];
    self.circleChart2.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;
    self.circleChart2.circle.lineCap = kCALineCapSquare;
    self.circleChart2.lineWidth = @11.0f;
    [self.circleChart2 setStrokeColor:[UIColor colorWithRed:89.0/255 green:203.0/255 blue:92/255 alpha:1]];
    [self.circleChart2 strokeChart];
    [self.memoryChartGroup addSubview:self.circleChart2];
    
    self.circleChart3 = [[PNCircleChart alloc] initWithFrame:self.storageChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.poolVO storageRatio]] andClockwise:YES andShadow:YES];
    self.circleChart3.backgroundColor = [UIColor clearColor];
    self.circleChart3.strokeColor = [UIColor clearColor];
    self.circleChart3.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
    self.circleChart3.circle.lineCap = kCALineCapSquare;//直角填充
    self.circleChart3.lineWidth = @11.0f;//线宽度
    [self.circleChart3 setStrokeColor:[UIColor colorWithRed:89.0/255 green:203.0/255 blue:92/255 alpha:1]];//已使用填充颜色
    [self.circleChart3 strokeChart];
    [self.storageChartGroup addSubview:self.circleChart3];
    
}
- (void)refreshElasticInfo{
    //self.elasticModel.text = self.elasticInfo.balancingMode;
    self.cpuLoadBalancing.text = [NSString stringWithFormat:@"%.0f%%", self.elasticInfo.cpuThreshold*100];
    self.memeryLoadBalancing.text = [NSString stringWithFormat:@"%.0f%%", self.elasticInfo.memThreshold*100];
    self.intervalTime.text = [self.elasticInfo intervalTime_text];
    self.nextCheckTime.text = [self.elasticInfo.nextStartTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
}

@end
