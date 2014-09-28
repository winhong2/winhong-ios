//
//  ViewController.m
//  InfiniteTreeView
//
//  Created by Sword on 14-5-6.
//  Copyright (c) 2014年 Sword. All rights reserved.
//

#import "ContactView.h"
#import "InfiniteTreeView.h"

@interface ContactView ()<PushTreeViewDataSource, PushTreeViewDelegate>
@property (weak, nonatomic) IBOutlet InfiniteTreeView *pushTreeView;

@end

@implementation ContactView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pushTreeView.dataSource = self;
    self.pushTreeView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PushTreeViewDataSource
- (NSInteger)numberOfSectionsInLevel:(NSInteger)level
{
    return 1;
    //return 2 * level + 1;
}

- (NSInteger)numberOfRowsInLevel:(NSInteger)level section:(NSInteger)section
{
    return 15;//level * section + 1;
}

- (UITableViewCell *)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level indexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier = @"UserInfoCell";
    UITableViewCell *cell = (UITableViewCell*)[pushTreeView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *section_formats = [[NSArray alloc] initWithObjects:@"运营商%ld%ld%ld", @"数据中心%ld%ld%ld", @"虚拟化类型%ld%ld%ld", @"资源池%ld%ld%ld", @"物理主机%ld%ld%ld", @"虚拟主机%ld%ld%ld", nil];
    
    cell.textLabel.text = [NSString stringWithFormat:[section_formats objectAtIndex:level%section_formats.count], level, indexPath.row, rand() % 10];
    
    return cell;
}

#pragma mark - PushTreeViewDelegate
- (void)pushTreeView:(InfiniteTreeView *)pushTreeView didSelectedLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath
{

}

-(NSString *)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level titleForHeaderInSection:(NSInteger)section{
    NSArray *section_formats = [[NSArray alloc] initWithObjects:@"运营商", @"数据中心", @"虚拟化类型", @"资源池", @"物理主机", @"虚拟主机", nil];
    return [section_formats objectAtIndex:level%section_formats.count];
}
//- (UIView *)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat headerHeight = 24;
//    UIView *headerview = nil;
//    headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
//    headerview.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:247/255.0 alpha:1.0];
//    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, headerHeight)];
//    NSArray *section_formats = [[NSArray alloc] initWithObjects:@"运营商", @"数据中心", @"虚拟化类型", @"资源池", @"物理主机", @"虚拟主机", nil];
//    titL.text = [section_formats objectAtIndex:level%section_formats.count];
//    titL.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
//    titL.backgroundColor = [UIColor clearColor];
//    titL.font = [UIFont boldSystemFontOfSize:12];
//    [headerview addSubview:titL];
//    return headerview;
//}



- (BOOL)pushTreeViewHasNextLevel:(InfiniteTreeView *)pushTreeView currentLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath
{
    BOOL next = TRUE;
    if (level == 5) {
        next = FALSE;
    }
    return next;
}

- (void)pushTreeViewWillReloadAtLevel:(InfiniteTreeView*)pushTreeView currentLevel:(NSInteger)currentLevel level:(NSInteger)level                            indexPath:(NSIndexPath*)indexPath
{
    NSLog(@"current level %d level %d", currentLevel, level);
}



#pragma mark - IBAction methods
- (IBAction)onBackBtnTouched:(id)sender
{
    if (self.pushTreeView.level >= 1) {
        [self.pushTreeView back];
    }
}

@end
