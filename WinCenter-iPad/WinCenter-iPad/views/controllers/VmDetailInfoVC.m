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

@end

@implementation VmDetailInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:getVmDetailUrl, self.datacenterVO.id, self.baseObject.vmId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        self.baseObject = [[VmVO alloc] initWithJSONData:jsonResponse.rawBody];
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }];
}
- (void)refresh{
    self.osType.text = self.baseObject.osType;
    self.isInstalledTool.text = self.baseObject.isInstallTools;
    self.runningTime.text = [NSString stringWithFormat:@"%d", self.baseObject.runTime];
    self.vcpu.text = [NSString stringWithFormat:@"%d", self.baseObject.vcpu];
    //self.isDynamicCPU
    self.memoryType.text = self.baseObject.memoryType;
    //self.isDynamicMemWce
    self.memory.text = [NSString stringWithFormat:@"%d", self.baseObject.memory];
    //self.snopshotNum.text
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
