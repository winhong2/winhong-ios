//
//  StaffSelect.h
//  zkuyun
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StaffSelect;

@protocol StaffSelectDelegate <NSObject>
- (void)select:(StaffSelect *)controller;
@end

@interface StaffSelect : UITableViewController
@property (nonatomic, weak) id <StaffSelectDelegate> delegate;



@end
