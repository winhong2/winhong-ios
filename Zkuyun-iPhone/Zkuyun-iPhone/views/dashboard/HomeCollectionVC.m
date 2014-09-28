//
//  HomeCollectionVC.m
//  Zkuyun-iPhone
//
//  Created by apple on 14-9-2.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "HomeCollectionVC.h"
#import "HomeCollectionCell.h"
#import "HomeCollectionHeader.h"


@interface HomeCollectionVC ()

@end

@implementation HomeCollectionVC

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIImageView *bg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    bg.image = [UIImage imageNamed:@"home_bg"];
//    self.collectionView.backgroundView = bg;
    
  

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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[@"HomeCollectionCell_Dynamic", @"HomeCollectionCell_Notice", @"HomeCollectionCell_SystemNotice", @"HomeCollectionCell_MM", @"HomeCollectionCell_PM", @"HomeCollectionCell_Audit", @"HomeCollectionCell_App"];
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:array[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeCollectionHeader" forIndexPath:indexPath];
    
    [header.eScrollerView initWithImageArray:[NSArray arrayWithObjects:@"EScrollerView_1.jpg",@"EScrollerView_2.jpg",@"EScrollerView_3.jpg", nil] TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33", nil]];
    
    return header;
}

@end
