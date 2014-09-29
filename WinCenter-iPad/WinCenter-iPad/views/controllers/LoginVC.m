//
//  LoginVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-20.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "LoginVC.h"
#import "LoginResult.h"
#import "MasterContainerVC.h"

@interface LoginVC ()
@property NSArray *datacenters;
@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationeryteryt
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSUserDefaults standardUserDefaults] setValue:@"https://192.168.100.146:8090" forKey:@"SERVER_ROOT"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"login%d", rand()%2+1]]];
    imageView.frame = [[UIScreen mainScreen] bounds];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.userName becomeFirstResponder];
}
- (IBAction)exitInput:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

        [[NSUserDefaults standardUserDefaults] setValue:@"FAILED" forKey:@"LOGIN_STATE"];
        
        [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
            [simpleRequest setUrl:postLoginUrl];
            [simpleRequest setParameters:@{@"userName":self.userName.text, @"password":self.password.text}];
        }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {

            dispatch_sync(dispatch_get_main_queue(), ^{
                if([[[NSUserDefaults standardUserDefaults] stringForKey:@"LOGIN_STATE"] isEqualToString:@"SUCCESS"]){
                    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                        [simpleRequest setUrl:getDatacenterListUrl];
                    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                        DatacenterListResult *result = [[DatacenterListResult alloc] initWithJSONData:jsonResponse.rawBody];
                        self.datacenters = result.dataCenters;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"toLogin" sender:self];
                        });
                        
                    }];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录提示" message:@"用户名或密码错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            });
            
        }];
  
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    if([segue.identifier isEqualToString:@"toLogin"]){
        MasterContainerVC *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
        if(self.datacenters.count>0){
            vc.datacenterVO = [self.datacenters firstObject];
            vc.baseObject = [self.datacenters firstObject];
        }
    }
}

- (IBAction)backToLogin:(UIStoryboardSegue*)segue{
    
}

@end
