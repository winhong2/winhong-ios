//
//  LoginView.h
//  zkuyun
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreView.h"

@interface LoginView : UITableViewController <MoreViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;

@end
