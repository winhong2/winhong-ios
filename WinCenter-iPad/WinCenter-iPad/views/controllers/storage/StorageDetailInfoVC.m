//
//  StorageDetailVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-18.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "StorageDetailInfoVC.h"
#import "StorageDiskCollectionCell.h"

@interface StorageDetailInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *totalStorage;
@property (weak, nonatomic) IBOutlet UILabel *volumeNum;
@property (weak, nonatomic) IBOutlet UILabel *hostNum;
@property (weak, nonatomic) IBOutlet UILabel *vmNum;
@property (weak, nonatomic) IBOutlet UIImageView *shared;
@property (weak, nonatomic) IBOutlet UILabel *defaulted_label;
@property (weak, nonatomic) IBOutlet UIImageView *defaulted;
@property (weak, nonatomic) IBOutlet UILabel *totalStorageLabel1;
@property (weak, nonatomic) IBOutlet UILabel *totalStorageLabel2;
@property (weak, nonatomic) IBOutlet UILabel *usedStorageLabel;
@property (weak, nonatomic) IBOutlet UILabel *allocatedStorageLabel;
@property (weak, nonatomic) IBOutlet UIView *usedStorageGroup;
@property (weak, nonatomic) IBOutlet UIView *allocatedStorageGroup;
@property (weak, nonatomic) IBOutlet UILabel *usedRatio;
@property (weak, nonatomic) IBOutlet UILabel *allocatedRatio;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation StorageDetailInfoVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toDiskCollection"]){
        StorageDiskCollectionVC *diskCollectionVC = segue.destinationViewController;
        diskCollectionVC.storageVO = self.storageVO;
    }
}

- (void)viewDidLayoutSubviews{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeMake(320, 1100);
    }
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [self.storageVO getStorageVOAsync:^(id object, NSError *error) {
        self.storageVO = object;
        [self refreshMainInfo];
    }];
}
- (void)refreshMainInfo{
    self.totalStorage.text = [NSString stringWithFormat:@"%.2f", self.storageVO.totalStorage];
    self.volumeNum.text = [NSString stringWithFormat:@"%d", self.storageVO.volumeNum];
    self.hostNum.text = [NSString stringWithFormat:@"%d", self.storageVO.hostNum];
    self.vmNum.text = [NSString stringWithFormat:@"%d", self.storageVO.vmNum];
    self.shared.hidden = [self.storageVO.shared isEqualToString:@"false"];
    self.defaulted.hidden = [self.storageVO.defaulted isEqualToString:@"false"];
    self.defaulted_label.hidden = [self.storageVO.defaulted isEqualToString:@"false"];
    
    self.totalStorageLabel1.text = [NSString stringWithFormat:@"%.2fGB", self.storageVO.totalStorage];
    self.totalStorageLabel2.text = [NSString stringWithFormat:@"%.2fGB", self.storageVO.totalStorage];
    self.usedStorageLabel.text = [NSString stringWithFormat:@"%.2fGB", (self.storageVO.totalStorage-self.storageVO.availStorage)];
    self.allocatedStorageLabel.text = [NSString stringWithFormat:@"%.2fGB", self.storageVO.allocatedStorage];
    
    self.usedRatio.text = [NSString stringWithFormat:@"%.0f %%", [self.storageVO usedRatio]];
    self.allocatedRatio.text = [NSString stringWithFormat:@"%.0f %%", [self.storageVO allocatedRatio]];
    
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:self.usedStorageGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.storageVO usedRatio]] andClockwise:YES andShadow:YES];
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.labelColor = [UIColor clearColor];
    [circleChart setStrokeColor:[self.storageVO usedRatioColor]];
    [circleChart strokeChart];
    [self.usedStorageGroup addSubview:circleChart];
    
    PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:self.allocatedStorageGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.storageVO allocatedRatio]] andClockwise:YES andShadow:YES];
    circleChart2.backgroundColor = [UIColor clearColor];
    circleChart2.labelColor = [UIColor clearColor];
    [circleChart2 setStrokeColor:[self.storageVO allocatedRatioColor]];
    [circleChart2 strokeChart];
    [self.allocatedStorageGroup addSubview:circleChart2];
}




@end
