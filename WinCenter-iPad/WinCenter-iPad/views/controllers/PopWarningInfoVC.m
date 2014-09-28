//
//  WarningInfoVC.m
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-26.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "PopWarningInfoVC.h"
#import "PopWarningInfoCell.h"
#import "PopWarningInfoCellForTime.h"

@interface PopWarningInfoVC ()

@end

@implementation PopWarningInfoVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:{
            PopWarningInfoCellForTime *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCellForTime" forIndexPath:indexPath];
            
            return cell;
        }
        case 1:{
            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
            
            return cell;
        }
        case 2:{
            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
            
            return cell;
        }
        case 3:{
            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
            
            return cell;
        }
        case 4:{
            PopWarningInfoCellForTime *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCellForTime" forIndexPath:indexPath];
            
            return cell;
        }
        case 5:{
            PopWarningInfoCellForTime *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCellForTime" forIndexPath:indexPath];
            
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return 44;
        }
        case 1:{
            return 120;
        }
        case 2:{
            return 120;
        }
        case 3:{
            return 120;
        }
        case 4:{
            return 40;
        }
        case 5:{
            return 40;
        }
        default:
            break;
    }
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"2014-07-13 星期三";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
