//
//  WeiboNewView.h
//  zkuyun
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffSelect.h"

@class WeiboNewView;

@protocol WeiboNewViewDelegate <NSObject>
- (void)cancel:(WeiboNewView *)controller;
- (void)done:(WeiboNewView *)controller;
@end

@interface WeiboNewView : UITableViewController <StaffSelectDelegate>
@property (nonatomic, weak) id <WeiboNewViewDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
