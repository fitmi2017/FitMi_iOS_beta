//
//  DeviceLog.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 27/11/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "DeviceLog.h"

@implementation DeviceLog

-(void)saveUserDeviceDataLog
{
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_device_log (user_id,userprofile_id,device_type,status, log_time,added_date) values ('%@','%@','%@','%@','%@','%@')",self.log_user_id,self.log_user_profile_id,self.deviceType,self.deviceStatus,self.log_log_time,self.log_date_added];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
  
}
-(NSMutableArray*)getAllDeviceDataLog:(NSString *)logDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_device_log where userprofile_id='%@'",userProfileID];
        
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"log_id"];
            [dic setValue:[rs stringForColumn:@"device_type"] forKey:@"device_type"];
            [dic setValue:[rs stringForColumn:@"status"] forKey:@"device_status"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
            [dic setValue:[[[rs stringForColumn:@"log_time"]componentsSeparatedByString:@" "]objectAtIndex:0] forKey:@"log_date"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;

}

-(BOOL)updateDeviceData:(NSString *)deviceType withStatusVal:(NSString *)strStatusVal
            withLogDate:(NSString *)logDate withUserProfileID:(NSString *)userProfileID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_device_log set  status='%@' where device_type='%@' AND userprofile_id='%@'",strStatusVal,deviceType,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
 
}
@end
