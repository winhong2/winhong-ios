//
//  VmContainerVC.h
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "MasterContainerVC.h"

@interface VmContainerVC : MasterContainerVC

@property VmVO *vmVO;
@property (weak, nonatomic) IBOutlet UIView *vmControlButtons;

@end