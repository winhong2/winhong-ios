//
//  LoginTableVC.m
//  WinCenter-iPhone
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "LoginTableVC.h"

@interface LoginTableVC ()
@property NSArray *datacenters;
@end

@implementation LoginTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.userName becomeFirstResponder];
}
- (IBAction)exitInput:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)enjoyAction:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"isDemo"];
    [[NSUserDefaults standardUserDefaults] setValue:@"SUCCESS" forKey:@"LOGIN_STATE"];
    [self toLogin];
}

- (IBAction)loginAction:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    NSString *msg = @"";
    if ([self.userName.text isEqualToString:@""]) {
        msg = @"用户名不能为空！";
    }else if([self.password.text isEqualToString:@""]){
        msg = @"密码不能为空！";
    }
    
    if ([msg isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"isDemo"];
        
        [LoginVO login:self.userName.text withPassword:self.password.text withSucceedBlock:^(NSError *error){
            [self toLogin];
        } withFailedBlock:^(NSError *error){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录提示" message:@"用户名或密码错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) toLogin{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Datacenter" bundle:nil] instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)backToLogin:(UIStoryboardSegue*)segue{
    
}

@end
