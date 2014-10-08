//
//  StorageDetailVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-18.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "StorageDetailInfoVC.h"
#import "StorageDetailDiskCell.h"

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


@end

@implementation StorageDetailInfoVC

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [self.storageVO getStorageVOAsync:^(id object, NSError *error) {
        self.storageVO = object;
        [self refreshMainInfo];
    }];
    
    [self.storageVO getStorageVolumnListAsync:^(NSArray *allRemote, NSError *error) {
        self.dataList = allRemote;
        [self refresh];
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
- (void)refresh{
    self.collectionHeader.text = [NSString stringWithFormat:@"虚拟磁盘(%li)", self.dataList.count];
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StorageDetailDiskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StorageDetailDiskCell" forIndexPath:indexPath];
    
    StorageVolumnVO *volumnVO = self.dataList[indexPath.row];
    cell.name.text = volumnVO.name;
    cell.state.text = [volumnVO state_text];
    cell.isASnapshot.text = [volumnVO isASnapshot_text];
    cell.size.text = [NSString stringWithFormat:@"%dGB", volumnVO.size];
    cell.belongsVM.text = [volumnVO vmNames_text];
    cell.type.text = [volumnVO type_text];
    return cell;
}


@end
