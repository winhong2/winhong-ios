//
//  LoginVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-20.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "LoginVC.h"
#import "UserListResult.h"
#import "MasterContainerVC.h"

@interface LoginVC ()
@property NSArray *datacenters;
@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.themeName!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:self.themeName forKey:@"Storyboard_Theme"];
    }
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

    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Datacenter"] instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)backToLogin:(UIStoryboardSegue*)segue{
    
}

@end
