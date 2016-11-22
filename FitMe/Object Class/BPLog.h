//
//  BPLog.h
//  FitMe
//
//  Created by Debasish on 21/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"

@interface BPLog : NSObject
@property(nonatomic,strong)NSString *log_user_id;
@property(nonatomic,strong)NSString *log_bp_id;
@property(nonatomic,strong)NSString *log_user_profile_id;
@property(nonatomic,strong)NSString *sysVal;
@property(nonatomic,strong)NSString *diaVal;
@property(nonatomic,strong)NSString *pulseVal;
@property(nonatomic,strong)NSString *log_log_time;
@property(nonatomic,strong)NSString *log_date_added;

-(void)saveUserBPDataLog;
-(NSMutableArray*)getAllBPDataLog:(NSString *)fromDate toDate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;

-(BOOL)updateBPData:(NSString *)bpID withSysVal:(NSString *)strSysVal withDiaVal:(NSString *)strDiaVal withPulseVal:(NSString *)strPulseVal;
-(BOOL)deleteBPData:(NSString *)bpID;
-(NSMutableDictionary *)getBP:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
@end
