//
//  BPLog.m
//  FitMe
//
//  Created by Debasish on 21/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "BPLog.h"

@implementation BPLog

-(void)saveUserBPDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_bp_log (user_id,userprofile_id,sys,dia,pulse, log_time,added_date) values ('%@','%@','%@','%@','%@','%@','%@')",self.log_user_id,self.log_user_profile_id,self.sysVal,self.diaVal,self.pulseVal,self.log_log_time,self.log_date_added];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
}

-(NSMutableArray*)getAllBPDataLog:(NSString *)fromDate toDate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_bp_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND userprofile_id='%@' order by id desc",fromDate,toDate,userProfileID];

        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"bp_id"];
            [dic setValue:[rs stringForColumn:@"sys"] forKey:@"sys"];
            [dic setValue:[rs stringForColumn:@"dia"] forKey:@"dia"];
            [dic setValue:[rs stringForColumn:@"pulse"] forKey:@"pulse"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
            [dic setValue:[[[rs stringForColumn:@"log_time"]componentsSeparatedByString:@" "]objectAtIndex:0] forKey:@"log_date"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}

-(BOOL)updateBPData:(NSString *)bpID withSysVal:(NSString *)strSysVal withDiaVal:(NSString *)strDiaVal withPulseVal:(NSString *)strPulseVal
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_bp_log set  sys='%@',dia='%@',pulse='%@' where id='%@'",strSysVal,strDiaVal,strPulseVal,bpID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
  
}

-(BOOL)deleteBPData:(NSString *)bpID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete  from fitmi_bp_log  where id='%@'",bpID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}
-(NSMutableDictionary *)getBP:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT * FROM fitmi_bp_log WHERE log_time  between '%@ 00:00:01' and  '%@ 23:59:59' AND userprofile_id='%@'",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[rs stringForColumn:@"sys"] forKey:@"sys"];
             [dic setValue:[rs stringForColumn:@"dia"] forKey:@"dia"];
             [dic setValue:[rs stringForColumn:@"pulse"] forKey:@"pulse"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return dic;
    
}

@end
