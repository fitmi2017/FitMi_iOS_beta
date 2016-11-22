//
//  WaterLog.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 21/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "WaterLog.h"

@implementation WaterLog
-(void)saveUserWaterDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_water_log (user_id,userprofile_id,oz,log_time,date_added) values ('%@','%@','%@','%@','%@')",self.waterlog_user_id,self.waterlog_user_profile_id,self.waterlog_quantity,self.water_log_time,self.waterlog_date_added];
            [[DbController mDBHandler] executeUpdate:sqlQry];
            [[DbController mDBHandler] commit];
    }
    
}


-(NSMutableArray*)getAllWaterLog:(NSString *)logDate withUserProfileID:(NSString *)userProfileID
{

    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_water_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND userprofile_id='%@' order by id desc",logDate,logDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"water_id"];
            [dic setValue:[rs stringForColumn:@"date_added"] forKey:@"date_added"];
            [dic setValue:[rs stringForColumn:@"oz"] forKey:@"oz"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;




}

-(BOOL)updateWaterData:(NSString *)waterID withWaterVal:(NSString *)strWaterVal
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_water_log set  oz='%@' where id='%@'",strWaterVal,waterID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

-(float)getWaterSumBurned:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT SUM(oz) as sum1 FROM fitmi_water_log WHERE log_time  between '%@ 00:00:01' and  '%@ 23:59:59' AND userprofile_id='%@'",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
           // [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
             [dic setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]floatValue];
    
}
-(BOOL)deleteWaterData:(NSString *)waterID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete  from fitmi_water_log  where id='%@'",waterID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

@end
