//
//  storageVO.m
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-28.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "StorageVO.h"

@implementation StorageVO
-(NSString *)state_text{
    NSDictionary *state_dict = @{
                                 @"OK":@"活动",
                                 @"plugException":@"挂载异常",
                                 @"unPlug":@"未挂载"
                                 };
    NSString *result = [state_dict valueForKey:self.state];
    
    if((result==nil) || [result isEqualToString:@""]){
        result = self.state;
    }
    return result;
}
-(NSString *)shared_text{
    NSDictionary *shared_dict = @{
                                 @"false":@"非共享",
                                 @"true":@"共享"
                                 };
    NSString *result = [shared_dict valueForKey:self.shared];
    
    if((result==nil) || [result isEqualToString:@""]){
        result = self.shared;
    }
    return result;
}


-(float)usedRatio{
    return (self.totalStorage - self.availStorage)/self.totalStorage*100;
}

-(UIColor *)usedRatioColor{
    float ratio = [self usedRatio];
    if(ratio>80){
        return PNRed;
    }else if(ratio>60){
        return PNYellow;
    }else{
        return PNGreen;
    }
}

-(float)allocatedRatio{
    return self.allocatedStorage/self.totalStorage*100;
}

-(UIColor *)allocatedRatioColor{
    float ratio = [self allocatedRatio];
    if(ratio>80){
        return PNRed;
    }else if(ratio>60){
        return PNYellow;
    }else{
        return PNGreen;
    }
}
@end
