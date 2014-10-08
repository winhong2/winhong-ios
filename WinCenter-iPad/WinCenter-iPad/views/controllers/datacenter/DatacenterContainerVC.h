//
//  DatacenterContainerVC.h
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "MasterContainerVC.h"

@interface DatacenterContainerVC : MasterContainerVC<DatacenterTableVCDelegate>

@property UIPopoverController *popoverVC;
@property DatacenterDetailInfoVC *infoVC;

@property (weak, nonatomic) IBOutlet UIButton *buttonConfig;
@property (weak, nonatomic) IBOutlet UIButton *buttonTask;
@property (weak, nonatomic) IBOutlet UIButton *buttonWarning;

@end
