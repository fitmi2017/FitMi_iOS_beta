//
//  UnitsLog.m
//  FitMe
//
//  Created by Debasish on 23/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UnitsLog.h"

@implementation UnitsLog

-(void)saveUserUnitDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_units_log (user_id,user_profile_id,unit_id,type) values ('%@','%@','%@','%@')",self.unitlog_user_id,self.unitlog_user_profile_id,self.unit_id,self.unit_type];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        [[DbController mDBHandler] commit];
    }
    
}

-(BOOL)updateUserUnitDataLog:(NSString *)unitType
{
BOOL isSuccess;
if (![DbController mDBHandler].inUse) {
    [[DbController mDBHandler] beginTransaction];
    
    NSString *sqlQry=[NSString stringWithFormat:@"update fitmi_units_log set  unit_id='%@' where type='%@'",self.unit_id,unitType];
    
    isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
    
    [[DbController mDBHandler] commit];
}
return isSuccess;
}


-(NSMutableArray*)getAllUnitDataLog:(NSString *)userProfileID
{
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_units_log where user_profile_id='%@'",userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[rs stringForColumn:@"unit_id"] forKey:@"unit_id"];
            [dic setValue:[rs stringForColumn:@"user_id"] forKey:@"user_id"];
            [dic setValue:[rs stringForColumn:@"user_profile_id"] forKey:@"user_profile_id"];
            [dic setValue:[rs stringForColumn:@"type"] forKey:@"type"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
}

-(NSString *)getUnitTypeID:(NSString *)unitType withUnitCategory:(NSString *)unitCat
{
   NSString *unitTypeID=@"";
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_units where type='%@' and unit='%@'",unitCat,unitType];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            unitTypeID=[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] ;
                 
        }
        [[DbController mDBHandler] commit];
    }
    
    return unitTypeID;

}

-(NSString *)getUnitType:(NSString *)unitTypeID withUnitCategory:(NSString *)unitCat
{
    NSString *unitType=@"";
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_units where id='%@' and type='%@'",unitTypeID,unitCat];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            unitType=[rs stringForColumn:@"unit"];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return unitType;
    
}

-(NSString *)getselectedUnitTypeID:(NSString *)unitType withUserID:(NSString *)userID withUserProfileID:(NSString *)userProfileID
{
    NSString *unitTypeID=@"";
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_units_log where type='%@' and user_id='%@' and user_profile_id='%@'",unitType,userID,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            unitTypeID=[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] ;
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return unitTypeID;
    
}


@end
