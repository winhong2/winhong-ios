//
//  AboutView.m
//  Zkuyun-iPhone
//
//  Created by apple on 14-9-2.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "AboutView.h"
#import <QREncoder.h>

@interface AboutView ()
@property (weak, nonatomic) IBOutlet UIImageView *qrView;

@end

@implementation AboutView

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
    [super viewDidLoad];
    
    self.qrView.image = [QREncoder encode:@"http://www.zkuyun.com"];
	self.qrView.layer.magnificationFilter = kCAFilterNearest;
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
