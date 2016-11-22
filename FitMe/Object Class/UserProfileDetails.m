//
//  UserProfileDetails.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 10/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "UserProfileDetails.h"

@implementation UserProfileDetails
-(int)saveUserProfileDetails{
    
    int rowId=0;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into user_profiles (user_id,first_name,last_name,email,gender,locale,full_name,timezone ,updated_time,age,picture,city,state,zipcode,tags,height_ft, height_in,weight,date_of_birth,activity_level,daily_calorie_intake,job ,religion,status,dislikes,about,options,last_sync_dt,last_sync_device,unit,image_url, username,created_on,verified,active,deleted)values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%d','%d')",self.user_id,self.first_name,self.last_name,@"",self.gender,@"",self.full_name,@"",@"",self.age,self.image_path,@"",@"",@"",@"",self.height_ft,self.height_in,self.weight,self.dob,self.activity_level,self.daily_calorie_intake,@"",@"",@"",@"",@"",@"",@"",@"",@"",self.image_path,self.full_name,@"",0,1,0];
       // [[DbController mDBHandler] executeUpdate:sqlQry];
        
         rowId=[[DbController mDBHandler] saveProfileUser:sqlQry];
        
        [[DbController mDBHandler] commit];
        
       
    }
    
     return rowId;
}

/*-(NSInteger)getCountofUserProfile
{
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];

        NSString *sqlQry=[NSString stringWithFormat:@"SELECT Count(*) FROM user_profiles"];
        
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
}*/

-(BOOL)updateUserProfileDetails:(NSString *)userProfileID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
    NSString *sqlQry=[NSString stringWithFormat:@"update user_profiles set gender='%@',full_name='%@',first_name='%@',last_name='%@',age='%@',height_ft='%@',height_in='%@',weight='%@',date_of_birth='%@',activity_level='%@',daily_calorie_intake='%@', username='%@',cal_intake_status='%@' where id='%@'",self.gender,self.full_name,self.first_name,self.last_name,self.age,self.height_ft,self.height_in,self.weight,self.dob,self.activity_level,self.daily_calorie_intake,self.full_name,self.cal_intake_status,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

-(BOOL)updateUserProfileImg:(int)userProfileID withImagePath:(NSString*)imgPath
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
 
        NSString *sqlQry=[NSString stringWithFormat:@"update user_profiles set picture='%@' where id='%d'",imgPath,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}
-(BOOL)updateUserProfile:(NSString *)userProfileID withIntakeVal:(NSString *)strIntakeVal withColumnNm:(NSString *)strColumnNm
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"update user_profiles set  %@='%@' where id='%@'",strColumnNm,strIntakeVal,userProfileID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
}

-(NSMutableArray*)getUserProfileDetails:(NSString *)userProfileID
{
    NSMutableArray *userList = [[NSMutableArray alloc] init] ;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"SELECT * FROM user_profiles WHERE id=%@",userProfileID];
        
        userList=[[DbController mDBHandler] getProfileUserList:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return userList;
}

-(NSMutableArray*)getUserProfileList
{
    NSMutableArray *userList = [[NSMutableArray alloc] init] ;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];

        NSString *sqlQry=[NSString stringWithFormat:@"SELECT * FROM user_profiles"];

        userList=[[DbController mDBHandler] getProfileUserList:sqlQry];

        [[DbController mDBHandler] commit];
    }
    return userList;
}

-(BOOL)deleteUserData:(NSString *)userID
{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete  from user_profiles  where id='%@'",userID];
        
        isSuccess=[[DbController mDBHandler] updateTable:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    return isSuccess;
    
}

@end
