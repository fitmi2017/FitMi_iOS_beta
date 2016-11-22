//
//  UserCalDetails.m
//  FitMe
//
//  Created by Debasish on 14/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UserCalDetails.h"

@implementation UserCalDetails

-(void)saveUserCalorieDetails{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_calorie_baseline (user_id,user_profile_id,total_intake,total_burned,weight,sleep,water,bp_sys ,bp_dia)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.user_id,self.user_profile_id,self.total_intake,self.total_burned,self.weight,self.sleep,self.water,self.bp_sys,self.bp_dia];
        
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    
    
}
-(BOOL)updateUserCalorieDetails:(NSString *)userProfileID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_calorie_baseline set total_intake ='%@',total_burned='%@',weight='%@',sleep='%@',water='%@',bp_sys='%@',bp_dia='%@' where user_profile_id='%@'",self.total_intake,self.total_burned,self.weight,self.sleep,self.water,self.bp_sys,self.bp_dia,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

-(BOOL)updateUserCalorie:(NSString *)userProfileID withIntakeVal:(NSString *)strVal withColumnNm:(NSString *)strColumnNm
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_calorie_baseline set  %@='%@' where user_profile_id='%@'",strColumnNm,strVal,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

-(BOOL)updateUserBP:(NSString *)userProfileID withsysVal:(NSString *)strSysVal withdiaVal:(NSString *)strDiaVal
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_calorie_baseline set bp_sys='%@',bp_dia='%@'  where user_profile_id='%@'",strSysVal,strDiaVal,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

-(NSMutableArray*)getUserCalorieDetails:(NSString *)userProfileID
{
    NSMutableArray *userCalorieList = [[NSMutableArray alloc] init] ;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"SELECT * FROM fitmi_calorie_baseline WHERE user_profile_id=%@",userProfileID];
        
        userCalorieList=[[DbController mDBHandler] getUserCalorieList:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return userCalorieList;
}

@end
