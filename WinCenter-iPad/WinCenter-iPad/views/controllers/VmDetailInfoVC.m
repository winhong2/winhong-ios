//
//  VmDetailShowVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-21.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "VmDetailInfoVC.h"

@interface VmDetailInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *osType;
@property (weak, nonatomic) IBOutlet UILabel *isInstalledTool;
@property (weak, nonatomic) IBOutlet UILabel *runningTime;
@property (weak, nonatomic) IBOutlet UILabel *vcpu;
@property (weak, nonatomic) IBOutlet UIImageView *isDynamicCPU;
@property (weak, nonatomic) IBOutlet UILabel *memoryType;
@property (weak, nonatomic) IBOutlet UIImageView *isDynamicMemWce;
@property (weak, nonatomic) IBOutlet UILabel *memory;
@property (weak, nonatomic) IBOutlet UILabel *snopshotNum;
@property (weak, nonatomic) IBOutlet UIImageView *osType_image;

@end

@implementation VmDetailInfoVC

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [self.vmVO getVmVOAsync:^(id object, NSError *error) {
        self.vmVO = object;
        [self refresh];
    }];
}
- (void)refresh{
    self.osType.text = self.vmVO.osType;
    self.isInstalledTool.text = [self.vmVO isInstallTools_text];
    self.runningTime.text = [NSString stringWithFormat:@"%d", self.vmVO.runTime];
    self.vcpu.text = [NSString stringWithFormat:@"%d", self.vmVO.vcpu];
    //self.isDynamicCPU
    self.memoryType.text = self.vmVO.memoryType;
    //self.isDynamicMemWce
    self.memory.text = [NSString stringWithFormat:@"%d", self.vmVO.memory];
    //self.snopshotNum.text
    self.osType_image.image = [UIImage imageNamed:[self.vmVO osType_imageName]];
}

@end
