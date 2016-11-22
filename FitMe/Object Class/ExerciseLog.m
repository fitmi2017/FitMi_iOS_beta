//
//  ExerciseLog.m
//  FitMe
//
//  Created by Debasish on 17/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "ExerciseLog.h"

@implementation ExerciseLog

-(void)saveUserExerciseDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_exercise_log (user_id,user_profile_id,exercise_id,exercise_name,description,calories_burned,total_time_minutes, log_time,date_added) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.log_user_id,self.log_user_profile_id,self.log_exercise_id,self.log_item_title,self.log_item_desc,self.log_cals,self.log_total_time,self.log_log_time,self.log_date_added];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    
    
    
}

-(int)getActivitySumBurned:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT SUM(calories_burned) as sum1 FROM fitmi_exercise_log WHERE log_time  between '%@ 00:00:01' and  '%@ 23:59:59' AND user_profile_id='%@'",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}

-(int)getFoodSumIndividualCalorie:(NSString *)exerciseID withUserProfileID:(NSString *)userProfileID withDate:selectedDate
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT SUM(calories_burned) as sum1 FROM fitmi_exercise_log WHERE user_profile_id ='%@' AND exercise_id = '%@' AND log_time  between '%@ 00:00:01' and  '%@ 23:59:59'",userProfileID,exerciseID,selectedDate,selectedDate];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}

-(int)getFoodSumAllCalorie:(NSString *)exerciseID withUserProfileID:(NSString *)userProfileID withDate:selectedDate
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT SUM(calories_burned) as sum1 FROM fitmi_exercise_log WHERE user_profile_id ='%@'  AND log_time  between '%@ 00:00:01' and  '%@ 23:59:59'",userProfileID,selectedDate,selectedDate];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}

-(NSMutableArray*)getAllActivityLog:(NSString *)fromDate toDate:(NSString *)toDate withSelectedUserID:(NSString* )userProfileID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_exercise_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id ='%@' order by id desc",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"exercise_id"]] forKey:@"exercise_id"];
            [dic setValue:[rs stringForColumn:@"exercise_name"] forKey:@"exercise_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"description"];
            [dic setValue:[rs stringForColumn:@"calories_burned"] forKey:@"calories_burned"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"total_time_minutes"]] forKey:@"total_time"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;

}
-(NSMutableArray*)getParticularActivityLog:(NSString *)fromDate toDate:(NSString *)toDate withSelectedUserID:(NSString* )userProfileID withActivityTypeID:(NSString *)activityTypeID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_exercise_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id ='%@' AND exercise_id ='%@' order by id desc",fromDate,toDate,userProfileID,activityTypeID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"exercise_id"]] forKey:@"exercise_id"];
            [dic setValue:[rs stringForColumn:@"exercise_name"] forKey:@"exercise_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"description"];
            [dic setValue:[rs stringForColumn:@"calories_burned"] forKey:@"calories_burned"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"total_time_minutes"]] forKey:@"total_time"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}


-(NSMutableArray*)getMyActivityLog:(NSString* )userProfileID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_exercise_log WHERE user_profile_id ='%@' order by id desc",userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"exercise_id"]] forKey:@"exercise_id"];
            [dic setValue:[rs stringForColumn:@"exercise_name"] forKey:@"exercise_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"description"];
            [dic setValue:[rs stringForColumn:@"calories_burned"] forKey:@"calories_burned"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"total_time_minutes"]] forKey:@"total_time"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}

-(BOOL)updateActivityTime:(NSString *)activityID withTimeVal:(NSString *)strTimeVal withTotalCalVal:(NSString *)strTotalCal
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_exercise_log set total_time_minutes='%@',calories_burned='%@' where exercise_id='%@'",strTimeVal,strTotalCal,activityID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

-(BOOL)deleteActivityData:(NSString *)activityID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete  from fitmi_exercise_log  where exercise_id='%@'",activityID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
  
}

//////////////////   daily log ////////////////

-(BOOL)getDailyExerciseLog:(NSString *)exerciseTypeId withSelectedDate:(NSString *)selectedDate withUserProfileID:(NSString *)userProfileID{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id from fitmi_exercise_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id ='%@' order by id desc",selectedDate,selectedDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [arr addObject:dic];
            
        }
        
        [[DbController mDBHandler] commit];
        
        
    }
    
    if([arr count]>0)
        return 1;
    else
        return 0;

    
    
}

-(BOOL)deleteUserExerciseDataLog:(NSString *)exerciseId withSelectedDate:(NSString *)selectedDate withSelecteduser_id:(NSString *)selectedUserId{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete from fitmi_exercise_log  where user_profile_id=%@ AND log_time  between '%@ 00:00:01' AND '%@ 23:59:59'",selectedUserId,selectedDate,selectedDate];
        isSuccess=  [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
        
    }
    
    return isSuccess;
    
}
-(BOOL)getDeviceExerciseLog:(NSString *)exerciseName withSelectedDate:(NSString *)selectedDate withUserProfileID:(NSString *)userProfileID{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id from fitmi_exercise_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id ='%@' AND exercise_name ='%@' order by id desc",selectedDate,selectedDate,userProfileID,exerciseName];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [arr addObject:dic];
            
        }
        
        [[DbController mDBHandler] commit];
        
        if([arr count]>0)
            return 1;
        else
            return 0;
        
    }
    
    return arr;
    
    
}


-(BOOL)updateUserExerciseDataLog:(NSString *)activityNm andLogTime:(NSString *)strTimeVal withCalorieVal:(NSString *)strTotalCal withUserProfileID:(NSString *)userProfileID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_exercise_log set calories_burned='%@' where exercise_name='%@' AND log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id ='%@'",strTotalCal,activityNm,strTimeVal,strTimeVal,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

@end
