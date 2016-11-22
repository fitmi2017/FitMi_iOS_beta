//
//  SleepLog.m
//  FitMe
//
//  Created by Debasish on 15/10/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "SleepLog.h"
#import "DbController.h"
@implementation SleepLog
-(void)saveUserSleepDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_sleep_log (user_id,user_profile_id,hours,log_time,date_added) values ('%@','%@','%@','%@','%@')",self.sleeplog_user_id,self.sleeplog_user_profile_id,self.sleeplog_quantity,self.sleep_log_time,self.sleeplog_date_added];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        [[DbController mDBHandler] commit];
    }
    
}


-(NSMutableArray*)getAllSleepLog:(NSString *)logDate withUserProfileID:(NSString *)userProfileID
{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_sleep_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id='%@' order by id desc",logDate,logDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"sleep_id"];
            [dic setValue:[rs stringForColumn:@"date_added"] forKey:@"date_added"];
            [dic setValue:[rs stringForColumn:@"hours"] forKey:@"hours"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
    
    
}

-(BOOL)updateSleepData:(NSString *)sleepID withSleepVal:(NSString *)strSleepVal
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_sleep_log set  hours='%@' where id='%@'",strSleepVal,sleepID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

-(int)getSleepSumBurned:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT SUM(hours) as sum1 FROM fitmi_sleep_log WHERE log_time  between '%@ 00:00:01' and  '%@ 23:59:59' AND user_profile_id='%@'",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}
-(BOOL)deleteSleepData:(NSString *)sleepID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete  from fitmi_sleep_log  where id='%@'",sleepID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

@end

