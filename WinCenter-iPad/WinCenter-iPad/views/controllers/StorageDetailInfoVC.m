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
        [simpleRequest setUrl:[NSString stringWithFormat:getStorageDetailUrl, self.datacenterVO.id, self.baseObject.storagePoolId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.baseObject = [[StorageVO alloc] initWithJSONData:jsonResponse.rawBody];
        [self performSelectorOnMainThread:@selector(refreshMainInfo) withObject:nil waitUntilDone:NO];
    }];
    
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getStorageVolumn, self.datacenterVO.id, self.baseObject.storagePoolId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.dataList = [[StorageVolumnListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList;
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }];
}
- (void)refreshMainInfo{
    self.totalStorage.text = [NSString stringWithFormat:@"%.2f", self.baseObject.totalStorage];
    self.volumeNum.text = [NSString stringWithFormat:@"%d", self.baseObject.volumeNum];
    self.hostNum.text = [NSString stringWithFormat:@"%d", self.baseObject.hostNum];
    self.vmNum.text = [NSString stringWithFormat:@"%d", self.baseObject.vmNum];
    //共享
    //默认
    self.totalStorageLabel1.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.totalStorage];
    self.totalStorageLabel2.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.totalStorage];
    self.usedStorageLabel.text = [NSString stringWithFormat:@"%.2fGB", (self.baseObject.totalStorage-self.baseObject.availStorage)];
    self.allocatedStorageLabel.text = [NSString stringWithFormat:@"%.2fGB", self.baseObject.allocatedStorage];
    
    self.usedRatio.text = [NSString stringWithFormat:@"%.0f %%", [self.baseObject usedRatio]];
    self.allocatedRatio.text = [NSString stringWithFormat:@"%.0f %%", [self.baseObject allocatedRatio]];
    
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:self.usedStorageGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.baseObject usedRatio]] andClockwise:YES andShadow:YES];
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.labelColor = [UIColor clearColor];
    [circleChart setStrokeColor:[self.baseObject usedRatioColor]];
    [circleChart strokeChart];
    [self.usedStorageGroup addSubview:circleChart];
    
    PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:self.allocatedStorageGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:[self.baseObject allocatedRatio]] andClockwise:YES andShadow:YES];
    circleChart2.backgroundColor = [UIColor clearColor];
    circleChart2.labelColor = [UIColor clearColor];
    [circleChart2 setStrokeColor:[self.baseObject allocatedRatioColor]];
    [circleChart2 strokeChart];
    [self.allocatedStorageGroup addSubview:circleChart2];
}
- (void)refresh{
    self.collectionHeader.text = [NSString stringWithFormat:@"虚拟磁盘(%li)", self.dataList.count];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StorageDetailDiskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StorageDetailDiskCell" forIndexPath:indexPath];
    
    StorageVolumnVO *volumnVO = self.dataList[indexPath.row];
    cell.name.text = volumnVO.name;
    cell.state.text = volumnVO.state;
    cell.isASnapshot.text = volumnVO.isASnapshot;
    cell.size.text = [NSString stringWithFormat:@"%dGB", volumnVO.size];
    //cell.belongsVM.text
    cell.type.text = volumnVO.type;
    return cell;
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
