//
//  WeightLog.m
//  FitMe
//
//  Created by Debasish on 23/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "WeightLog.h"

@implementation WeightLog

-(void)saveUserWeightDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_weight_log (user_id,user_profile_id,weight, log_time,date_added) values ('%@','%@','%@','%@','%@')",self.log_user_id,self.log_user_profile_id,self.weightVal,self.log_log_time,self.log_date_added];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
}

-(NSMutableArray*)getAllWeightDataLog:(NSString *)fromDate toDate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_weight_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id='%@' order by id desc",fromDate,toDate,userProfileID];
   
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"weight_id"];
            [dic setValue:[rs stringForColumn:@"weight"] forKey:@"weight"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
            [dic setValue:[[[rs stringForColumn:@"log_time"]componentsSeparatedByString:@" "]objectAtIndex:0] forKey:@"log_date"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}

-(BOOL)updateWeightData:(NSString *)weightID withWeightVal:(NSString *)strWeightVal
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_weight_log set  weight='%@' where id='%@'",strWeightVal,weightID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

-(BOOL)deleteWeightData:(NSString *)weightID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete  from fitmi_weight_log  where id='%@'",weightID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}
-(int)getWeight:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT weight FROM fitmi_weight_log WHERE log_time  between '%@ 00:00:01' and  '%@ 23:59:59' AND user_profile_id='%@'",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[rs stringForColumn:@"weight"] forKey:@"weight"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"weight"]intValue];
 
}
@end

