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
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getWarningInfoUrl]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.dataList = [[WarningInfoListResult alloc] initWithJSONData:jsonResponse.rawBody].alarms;
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }];
}

-(void)refresh{
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarningInfoVO *warningVO = self.dataList[indexPath.row];
    //PopWarningInfoCellForTime *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCellForTime" forIndexPath:indexPath];
    
    //cell.label1.text = warningVO.createTime;
    PopWarningInfoCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
    
    cell2.label1.text = warningVO.name;
    cell2.label2.text = warningVO.createTime;
    cell2.label3.text = warningVO.objectName;
    cell2.label4.text = warningVO.body;

//    switch (indexPath.row) {
//        case 0:{
//            PopWarningInfoCellForTime *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCellForTime" forIndexPath:indexPath];
//            
//            cell.label1.text = warningVO.createTime;
//            
//            
//            return cell;
//        }
//        case 1:{
//            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
//
//            cell.label1.text = warningVO.name;
//            
//            return cell;
//        }
//        case 2:{
//            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
//
//            cell.label2.text = warningVO.createTime;
//            return cell;
//        }
//        case 3:{
//            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
//
//            cell.label3.text = warningVO.objectName;
//            return cell;
//        }
//        case 4:{
//            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
//
//            cell.label4.text = warningVO.body;
//            return cell;
//        }
//        case 5:{
//            PopWarningInfoCellForTime *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCellForTime" forIndexPath:indexPath];
//            
//            //cell.label1.text = warningVO.name;
//            
//            return cell;
//        }
//        default:{
//            PopWarningInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WarningInfoCell" forIndexPath:indexPath];
//            
//            //cell.label1.text = warningVO.name;
//            
//            return cell;
//        }
  //  }
    
    return cell2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.row) {
//        case 0:{
//            return 44;
//        }
//        case 1:{
//            return 120;
//        }
//        case 2:{
//            return 120;
//        }
//        case 3:{
//            return 120;
//        }
//        case 4:{
//            return 40;
//        }
//        case 5:{
//            return 40;
//        }
//        default:
//            break;
//    }
    return 120;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
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
