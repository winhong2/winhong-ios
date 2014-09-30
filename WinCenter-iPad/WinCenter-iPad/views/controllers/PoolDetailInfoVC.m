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

@end

@implementation PoolDetailInfoVC

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
        [simpleRequest setUrl:[NSString stringWithFormat:getPoolDetailUrl, self.datacenterVO.id, self.baseObject.resourcePoolId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.baseObject = [[PoolVO alloc] initWithJSONData:jsonResponse.rawBody];
        [self performSelectorOnMainThread:@selector(refreshMainInfo) withObject:nil waitUntilDone:NO];
    }];
    
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getPoolElasticUrl, self.datacenterVO.id, self.baseObject.resourcePoolId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.elasticInfo = [[PoolElasticInfo alloc] initWithJSONData:jsonResponse.rawBody];
        [self performSelectorOnMainThread:@selector(refreshElasticInfo) withObject:nil waitUntilDone:NO];
    }];
    
}

- (void)refreshMainInfo{
    self.hostCount.text = [NSString stringWithFormat:@"%d", self.baseObject.hostNumber];
    self.vmCount.text = [NSString stringWithFormat:@"%d", self.baseObject.vmNumber];
    
    self.cpuUnitCount.text = [NSString stringWithFormat:@"%.2fGHz", self.baseObject.totalCpu/1000.0];
    self.cpuUnitUsedCount.text = [NSString stringWithFormat:@"%.2fGHz", (self.baseObject.totalCpu-self.baseObject.availCpu)/1000.0];
    self.cpuUnitUnusedCount.text = [NSString stringWithFormat:@"%.2fGHz", self.baseObject.availCpu/1000.0];
    self.cpuRatio.text = [NSString stringWithFormat:@"%.0f%%", [self.baseObject cpuRatio]];
    
    self.memorySize.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.totalMemory/1024.0];
    self.memoryUsedSize.text = [NSString stringWithFormat:@"%.2fGB", (self.baseObject.totalMemory-self.baseObject.availMemory)/1024.0];
    self.memoryUnusedSize.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.availMemory/1024.0];
    self.memoryRatio.text = [NSString stringWithFormat:@"%.0f%%", (self.baseObject.totalMemory-self.baseObject.availMemory)/self.baseObject.totalMemory*100];
    
    self.storageSize.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.totalStorage/1024.0];
    self.storageUsedSize.text = [NSString stringWithFormat:@"%.2fGB", (self.baseObject.totalStorage - self.baseObject.availStorage)/1024.0];
    self.storageUnusedSize.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.availStorage/1024.0];
    self.storageRatio.text = [NSString stringWithFormat:@"%.0f%%", (self.baseObject.totalStorage-self.baseObject.availStorage)/self.baseObject.totalStorage*100];
    
    //self.haErrorHostCount.text = self.baseObject.haErrorHostCount;
    //self.haSignalNetwork.text = self.baseObject.haSignalNetwork;
    //self.haSignalPool.text = self.baseObject.haSignalPool;
    //圈图
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:self.cpuChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.baseObject cpuRatio]] andClockwise:YES andShadow:YES];
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.labelColor = [UIColor clearColor];
    [circleChart setStrokeColor:[self.baseObject cpuRatioColor]];
    [circleChart strokeChart];
    [self.cpuChartGroup addSubview:circleChart];
    
    
    PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:self.memoryChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.baseObject memoryRatio]] andClockwise:YES andShadow:YES];
    circleChart2.backgroundColor = [UIColor clearColor];
    circleChart2.labelColor = [UIColor clearColor];
    [circleChart2 setStrokeColor:[self.baseObject memoryRatioColor]];
    [circleChart2 strokeChart];
    [self.memoryChartGroup addSubview:circleChart2];
    
    PNCircleChart * circleChart3 = [[PNCircleChart alloc] initWithFrame:self.storageChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.baseObject storageRatio]] andClockwise:YES andShadow:YES];
    circleChart3.backgroundColor = [UIColor clearColor];
    circleChart3.labelColor = [UIColor clearColor];
    [circleChart3 setStrokeColor:[self.baseObject storageRatioColor]];
    [circleChart3 strokeChart];
    [self.storageChartGroup addSubview:circleChart3];
    
}
- (void)refreshElasticInfo{
    self.elasticModel.text = self.elasticInfo.balancingMode;
    self.cpuLoadBalancing.text = [NSString stringWithFormat:@"%.0f%%", self.elasticInfo.cpuThreshold*100];
    self.memeryLoadBalancing.text = [NSString stringWithFormat:@"%.0f%%", self.elasticInfo.memThreshold*100];
    self.intervalTime.text = self.elasticInfo.intervalTime;
    self.nextCheckTime.text = self.elasticInfo.nextStartTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
