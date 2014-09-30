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

@end

@implementation HostDetailInfoVC

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
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getHostDetailUrl, self.datacenterVO.id, self.baseObject.hostId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.baseObject = [[HostVO alloc] initWithJSONData:jsonResponse.rawBody];
        [self performSelectorOnMainThread:@selector(refreshMainInfo) withObject:nil waitUntilDone:NO];
    }];
    
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getHostStatUrl, self.datacenterVO.id, self.baseObject.hostId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.statVO = [[HostStatVO alloc] initWithJSONData:jsonResponse.rawBody];
        [self performSelectorOnMainThread:@selector(refreshStatInfo) withObject:nil waitUntilDone:NO];
    }];
}

- (void)refreshMainInfo{
    self.virtualMachineNum.text = [NSString stringWithFormat:@"%d", self.baseObject.virtualMachineNum];
    //self.activeMachineNum.text = [NSString stringWithFormat:@"%d", 0];
    self.networkNum.text = [NSString stringWithFormat:@"%d", self.baseObject.networkNum];
    self.startRunTime.text = [NSString stringWithFormat:@"%d", self.baseObject.startRunTime];
    self.virtualInfo.text = [NSString stringWithFormat:@"%@ %@", self.baseObject.virtualSoftware, self.baseObject.virtualVersion];
    self.virtualDate.text = [NSString stringWithFormat:@"%@", self.baseObject.versionDate];
    self.cpuSpeed.text = [NSString stringWithFormat:@"%dMHz", self.baseObject.cpuSpeed];
    self.model.text = [NSString stringWithFormat:@"%@", self.baseObject.model];
    self.vendor.text = [NSString stringWithFormat:@"%@", self.baseObject.vendor];
    self.cpuSlots.text = [NSString stringWithFormat:@"%d颗", self.baseObject.cpuSlots];
    self.cpu.text = [NSString stringWithFormat:@"%d个", self.baseObject.cpu];
    
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
