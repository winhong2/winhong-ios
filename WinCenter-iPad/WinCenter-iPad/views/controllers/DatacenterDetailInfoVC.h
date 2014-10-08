//
//  DatacenterDetailInfoVC.h
//  wincenterDemo01
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatacenterDetailInfoVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *poolCount;
@property (weak, nonatomic) IBOutlet UILabel *hostCount;
@property (weak, nonatomic) IBOutlet UILabel *vmCount;
@property (weak, nonatomic) IBOutlet UILabel *businessCount;

@property (weak, nonatomic) IBOutlet UILabel *cpuUnitCount;
@property (weak, nonatomic) IBOutlet UILabel *cpuUsedInfo;
@property (weak, nonatomic) IBOutlet UILabel *memerySize;
@property (weak, nonatomic) IBOutlet UILabel *memeryUsedInfo;
@property (weak, nonatomic) IBOutlet UILabel *storageSize;
@property (weak, nonatomic) IBOutlet UILabel *storageUsedInfo;
@property (weak, nonatomic) IBOutlet UILabel *networkIpCount;
@property (weak, nonatomic) IBOutlet UILabel *networkIpUsedInfo;


@property (weak, nonatomic) IBOutlet UIProgressView *cpuProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *memoryProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *storageProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *networkProgress;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;

- (void)refresh;
- (void)switchButtonSelected:(NSInteger)index;

@end
