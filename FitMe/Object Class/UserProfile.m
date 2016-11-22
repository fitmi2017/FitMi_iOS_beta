//
//  UserProfile.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 10/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
-(void)saveUserData{

    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into users (id,first_name,last_name,email_address,password,last_login_dt,last_logout_dt,last_active_dt,date_created,date_modified,suspended,canceled,active,deleted) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%d')",self.userID,self.fnameString,self.lnameString,self.emailString,self.passwordString,@"",@"",@"",@"",@"",0,0,1,0];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }


}


-(NSMutableArray *)loginCheck:(NSString *)emailStr password:(NSString *)pwdStr{
    NSMutableArray *arr=[NSMutableArray array];
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from users where email_address='%@' and password='%@'",emailStr,pwdStr];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"email_address"] forKey:@"email_address"];
            [arr addObject:dic];
        }
        
        [[DbController mDBHandler] commit];
    }
    
    
    return arr;



}

-(NSMutableArray *)getAllProfileID{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id from user_profiles order by id desc limit 1"];
        NSLog(@"sqlQry========%@",sqlQry);
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [arr addObject:dic];
        }
        
        [[DbController mDBHandler] commit];
    }
    
    
    return arr;
}



-(NSString *)getPWD:(NSString *)userID
{
    NSString *password=@"";
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from users where id='%@'",userID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            password=[rs stringForColumn:@"password"] ;
        }
        [[DbController mDBHandler] commit];
    }
    
    return password;
    
}


-(BOOL)updateUserPWD:(NSString *)userID withPasswordVal:(NSString *)strPassword
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update users set  password='%@' where id='%@'",strPassword,userID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

@end
