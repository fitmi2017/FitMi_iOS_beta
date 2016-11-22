//
//  SleepLog.h
//  FitMe
//
//  Created by Debasish on 15/10/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepLog : NSObject

@property(nonatomic,strong)NSString *sleeplog_user_id;
@property(nonatomic,strong)NSString *sleeplog_user_profile_id;
@property(nonatomic,strong)NSString *sleeplog_quantity;
@property(nonatomic,strong)NSString *sleep_log_time;
@property(nonatomic,strong)NSString *sleeplog_date_added;

-(void)saveUserSleepDataLog;
-(NSMutableArray*)getAllSleepLog:(NSString *)logDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)updateSleepData:(NSString *)sleepID withSleepVal:(NSString *)strSleepVal;
-(int)getSleepSumBurned:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)deleteSleepData:(NSString *)sleepID;
@end
