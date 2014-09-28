//
//  LoginView.m
//  zkuyun
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "LoginView.h"
//#import "AESCrypt.h"
//#import "TBXML.h"
//#import "TBXML+Compression.h"
//#import "TBXML+HTTP.h"

@interface LoginView ()

@end

@implementation LoginView

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
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bg.image = [UIImage imageNamed:@"login_bg"];
    self.tableView.backgroundView = bg;
    
    //NSError *error;
    //TBXML * tbxml = [TBXML newTBXMLWithXMLFile:@"books" fileExtension:@"xml" error:&error];
    
    //if (error) {
        //NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    //} else {
        //NSLog(@"%@", [TBXML elementName:tbxml.rootXMLElement]);
    //}

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
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self.username becomeFirstResponder];
    }else if(indexPath.section == 2){
        [self.password becomeFirstResponder];
    }else{
        [self.username resignFirstResponder];
        [self.password resignFirstResponder];
    }
}

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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login_segue"]) {
        UITabBarController *tabBarController = segue.destinationViewController;
        UINavigationController *navigationController = [tabBarController viewControllers][4];
        MoreView *moreView = [navigationController viewControllers][0];
        moreView.delegate = self;
    }
}

- (void) exit:(MoreView *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)login:(id)sender {
    
    NSString *msg = nil;
    
    if([[self username].text length] < 1){
        msg = @"请填写用户名";
    }else if([[self password].text length] < 6){
        msg = @"密码至少为6位";
    }
    
    if(msg != nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        //NSString *encryptedData = [AESCrypt encrypt:[self username].text password:[self password].text];
        //NSString *message = [AESCrypt decrypt:encryptedData password:[self password].text];
        //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //    [alert show];
        [self performSegueWithIdentifier:@"login_segue" sender:sender];
    }

}
@end
