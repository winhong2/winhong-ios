//
//  MoreView.h
//  zkuyun
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreView;

@protocol MoreViewDelegate <NSObject>
- (void)exit:(MoreView *)controller;
@end

@interface MoreView : UITableViewController
@property (nonatomic, weak) id <MoreViewDelegate> delegate;
- (IBAction)exit:(id)sender;

@end
