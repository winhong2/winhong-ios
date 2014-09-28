//
//  PopOptionsUserInfoVC.m
//  WinCenter-iPad
//
//  Created by huadi on 14-9-28.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PopOptionsUserInfoVC.h"

@interface PopOptionsUserInfoVC ()

@property UserVO *userVO;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *roleName;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *mobilephone;

@end

@implementation PopOptionsUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:getUserInfoUrl];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        
        LoginResult *loginResult = [[LoginResult alloc] initWithJSONData:jsonResponse.rawBody];
        self.userVO = loginResult.users[0];
        
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
        
    }];
}

-(void)refresh{
    self.name.text = self.userVO.name;
    self.account.text = self.userVO.account;
    self.roleName.text = self.userVO.roleName;
    self.email.text = self.userVO.email;
    self.mobilephone.text = self.userVO.mobilephone;
}


@end
