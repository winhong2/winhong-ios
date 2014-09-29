//
//  PopOptionLicenseVC.m
//  WinCenter-iPad
//
//  Created by huadi on 14-9-29.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PopOptionLicenseVC.h"

@interface PopOptionLicenseVC ()

@property LicenseVO *licenseVO;

@property (weak, nonatomic) IBOutlet UILabel *custName;
@property (weak, nonatomic) IBOutlet UILabel *orgName;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *IcType;
@property (weak, nonatomic) IBOutlet UILabel *useedInfo;
@property (weak, nonatomic) IBOutlet UILabel *remianDays;

@end

@implementation PopOptionLicenseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:getLicenseUrl];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        
        self.licenseVO = [[LicenseVO alloc] initWithJSONData:jsonResponse.rawBody];
        
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
        
    }];
}

-(void)refresh{
    self.custName.text = self.licenseVO.wci.custName;
    self.orgName.text = self.licenseVO.wci.orgName;
    self.email.text = self.licenseVO.wci.email;
    self.phone.text = self.licenseVO.wci.phone;
    self.IcType.text = self.licenseVO.wci.IcType;
    self.useedInfo.text = [NSString stringWithFormat:@"%d/%d", self.licenseVO.useedCount,self.licenseVO.wci.IcNum];
    self.remianDays.text = [NSString stringWithFormat:@"%d", self.licenseVO.remianDays];
}


@end
