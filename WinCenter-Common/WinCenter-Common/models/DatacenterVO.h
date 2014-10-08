//
//  DatacenterVO.h
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-27.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatacenterVO : RemoteObject
@property int id;
@property NSString *name;;
@property NSString *wceIpAddress;
@property int wcePort;
@property NSString *wceAccount;
@property NSString *wcePassword;
@property NSString *remark;
@property NSString *createTime;
@property NSString *lastUpdateTime;
@property BOOL busCanDel;
@property BOOL vdcCanDel;
@property BOOL resCaseCanDel;

+ (void) getDatacenterListAsync:(FetchAllCompletionBlock)completionBlock;
- (void) getDatacenterStatWinserverVOAsync:(FetchObjectCompletionBlock)completionBlock;
- (void) getBusinessListAsync:(FetchAllCompletionBlock)completionBlock;
- (void) getBusinessListAsync:(FetchAllCompletionBlock)completionBlock limit:(int)count;
- (void) getPoolListAsync:(FetchAllCompletionBlock)completionBlock;
- (void) getPoolListAsync:(FetchAllCompletionBlock)completionBlock limit:(int)count;
@end
