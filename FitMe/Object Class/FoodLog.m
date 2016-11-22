//
//  FoodLog.m
//  FitMe
//
//  Created by Krishnendu Ghosh on 15/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import "FoodLog.h"
#import "Utility.h"
@implementation FoodLog



-(BOOL)findID:(NSString *)selectedID withUserProfileID:userProfileID withmeal_id:(NSString *)meal_id withSelectedDate:(NSString*)selectedDate{

    BOOL is_success;
    NSMutableArray *arr=[NSMutableArray array];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id,food_name from fitmi_food_log  where reference_food_id = '%@'AND meal_id='%@'AND user_profile_id='%@' and log_time between '%@ 00:00:01' AND '%@ 23:59:59'",selectedID,meal_id,userProfileID,selectedDate,selectedDate];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
           
            [arr addObject:dic];
       
    }
        if([arr count]>0)
            is_success=1;
        else
            is_success=0;

  }
    [[DbController mDBHandler] commit];
    return is_success;
    
}

-(void)saveUserFoodDataLog{
   
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_food_log (user_id,user_profile_id,meal_id,food_name,description,cals,serving_size, reference_food_id,log_time,date_added,item_weight,gm_calorie) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.log_user_id,self.log_user_profile_id,self.log_meal_id,self.log_item_title,self.log_item_desc,self.log_cals,self.log_serving_size,self.log_reference_food_id,self.log_log_time,self.log_date_added,self.log_item_weight,self.log_gm_cal];
       [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
  

}

-(void)saveUserFavFoodDataLog{
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_food_log (user_id,user_profile_id,meal_id,food_name,description,cals,serving_size, reference_food_id,log_time,date_added,item_weight,gm_calorie,isFavorite) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.log_user_id,self.log_user_profile_id,self.log_meal_id,self.log_item_title,self.log_item_desc,self.log_cals,self.log_serving_size,self.log_reference_food_id,self.log_log_time,self.log_date_added,self.log_item_weight,self.log_gm_cal,@"1"];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    
    
}


-(BOOL)deleteUserFoodDataLog:(NSString *)mealId withSelectedDate:(NSString *)selectedDate withSelecteduser_id:(NSString *)selectedUserId{
     BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete from fitmi_food_log  where user_profile_id=%@ AND log_time  between '%@ 00:00:01' AND '%@ 23:59:59' and meal_id=%@",selectedUserId,selectedDate,selectedDate,mealId];
     isSuccess=  [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
        
    }
    
    return isSuccess;
    
}

-(BOOL)deleteRowFoodData:(NSString *)mealId withSelectedDate:(NSString *)selectedDate withUserId:(NSString *)userId{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        //NSString *sqlQry=[NSString stringWithFormat:@"delete from fitmi_food_log  where log_time  between '%@ 00:00:01' AND '%@ 23:59:59' and id='%@' and user_profile_id='%@'",selectedDate,selectedDate,mealId,userId];
        NSString *sqlQry=[NSString stringWithFormat:@"delete from fitmi_food_log  where  id='%@'",mealId];
        isSuccess=  [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
        
    }
    
    return isSuccess;
    
}

-(NSMutableArray*)getAllSnackLog{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id=4"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}
-(NSMutableArray*)getAllDinnerLog{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id=3"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}
-(NSMutableArray*)getAllFavoriteFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        if([selectedId isEqualToString: @"" ]){
          sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where  user_profile_id='%@' and isFavorite=1 group by reference_food_id",selectedUserId];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id='%@' AND user_profile_id='%@' and isFavorite=1 group by reference_food_id",selectedId,selectedUserId];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
             [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}
-(NSMutableArray*)getAllRecentFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        if([selectedId isEqualToString: @"" ]){
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where  user_profile_id='%@' limit 30",selectedUserId];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id='%@' AND user_profile_id='%@'  limit 30",selectedId,selectedUserId];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}


-(NSMutableArray*)getAllLunchLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        if([selectedDate isEqualToString: @"" ]){
           sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id='%@'  AND user_profile_id=%@ group by reference_food_id order by id",selectedId,selectedUserId];
        }
        else if ([selectedId isEqualToString:@""]){
          sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where   log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id=%@ group by reference_food_id order by id",selectedDate,selectedDate,selectedUserId];
        
        }
        
        else{
           sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id='%@' and log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id=%@ group by reference_food_id order by id",selectedId,selectedDate,selectedDate,selectedUserId];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

-(NSMutableArray*)getAllRefID:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
               sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id=%@",selectedDate,selectedDate,selectedUserId];
 
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:[dic objectForKey:@"item"]];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

-(NSMutableArray*)getAllBreakfastLog{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id=1"];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
             [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
}

-(NSMutableArray*)getAllFoodLog :(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        //NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log  where user_profile_id='%@' order by id desc limit 30",selectedUserId];
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log  where user_profile_id='%@' group by reference_food_id limit 30",selectedUserId];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
    
}

-(NSMutableArray*)getAllFoodLogForSync :(NSString*)selectedUserId
{
    NSMutableArray *arr=[NSMutableArray array];
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log  where user_profile_id='%@'",selectedUserId];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
    
}

-(int)getFoodSumCalorie:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE log_time  between '%@ 00:00:01' and  '%@ 23:59:59' AND user_profile_id='%@'",fromDate,toDate,userProfileID];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}

-(int)getFoodSumIndividualCalorie:(NSString *)mealID withUserProfileID:(NSString *)userProfileID withDate:(NSString *)date
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        NSString *sqlQry;
        if([mealID isEqualToString:@""]){
        sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE user_profile_id ='%@'  AND log_time  between '%@ 00:00:01' and  '%@ 23:59:59'",userProfileID,date,date];
        }
        else{
           sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE user_profile_id ='%@' AND meal_id = '%@' AND log_time  between '%@ 00:00:01' and  '%@ 23:59:59'",userProfileID,mealID,date,date];
            
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
  
}

-(int)getFoodSumIndividualCalorieFav:(NSString *)mealID withUserProfileID:(NSString *)userProfileID withDate:(NSString *)date
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        NSString *sqlQry;
        if([mealID isEqualToString:@""]){
            sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE user_profile_id ='%@'  AND isFavorite=1",userProfileID];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE user_profile_id ='%@' AND meal_id = '%@' AND isFavorite=1",userProfileID,mealID];
            
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}
-(int)getFoodSumIndividualCalorieRecent:(NSString *)mealID withUserProfileID:(NSString *)userProfileID withDate:(NSString *)date
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        NSString *sqlQry;
        if([mealID isEqualToString:@""]){
            sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE user_profile_id ='%@' limit 30",userProfileID];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"SELECT SUM(cals) as sum1 FROM fitmi_food_log WHERE user_profile_id ='%@' AND meal_id = '%@' limit 30",userProfileID,mealID];
            
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"sum1"]] forKey:@"sum1"];
        }
        [[DbController mDBHandler] commit];
    }
    
    return [[dic valueForKey:@"sum1"]intValue];
    
}

-(BOOL)getDailyFoodLog:(NSString *)mealTypeId withSelectedDate: (NSString *)selectedDate withUserProfileID:(NSString *)userProfileID
{
    
    NSMutableArray *arr=[NSMutableArray array];
    
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id from fitmi_food_log where  meal_id=%@ AND log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND user_profile_id ='%@'",mealTypeId,selectedDate,selectedDate,userProfileID];
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

-(void)updateFavoriteStatus:(NSString*)FavStatus foodID:(NSString *)food_ID  withUserProfileID:(NSString *)userProfileID withFoodRefID:(NSString *)food_Ref_ID
{
    BOOL is_success;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];

       // NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set isFavorite ='%@',isFavMeal='%@' where id = '%@' and user_profile_id='%@'",FavStatus,@"0",meal_ID,userProfileID];
        NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set isFavorite ='%@' where id = '%@' and user_profile_id='%@'",FavStatus,food_ID,userProfileID];
       // NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set isFavorite ='%@' where reference_food_id = '%@' and user_profile_id='%@'",FavStatus,food_Ref_ID,userProfileID];
        
        is_success=[[DbController mDBHandler] executeUpdate:sqlQry];
        [[DbController mDBHandler] commit];
    }
    
}

-(void)updateMealFavoriteStatus:(NSString*)FavStatus foodID:(NSString *)food_ID  withUserProfileID:(NSString *)userProfileID withMealFavStatus:(NSString*)MealFavStatus withFoodRefID:(NSString *)food_Ref_ID
{
    BOOL is_success;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
   
       // NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set isFavorite ='%@',isFavMeal='%@' where id = '%@' and user_profile_id='%@'",FavStatus,MealFavStatus,meal_ID,userProfileID];
        NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set isFavMeal='%@' where id = '%@' and user_profile_id='%@'",MealFavStatus,food_ID,userProfileID];
       //  NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set isFavMeal='%@' where reference_food_id = '%@' and user_profile_id='%@'",MealFavStatus,food_Ref_ID,userProfileID];
        is_success=[[DbController mDBHandler] executeUpdate:sqlQry];
        [[DbController mDBHandler] commit];
    }
    
}

-(void)updateGramLog:(NSString*)cals withWeight:(NSString*)weight withDate:(NSString*)date foodID:(NSString *)meal_ID  withUserProfileID:(NSString *)userProfileID{
    BOOL is_success;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        NSString *sqlQry;
        if([date isEqualToString:@""])
        {
            sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set cals ='%@' ,item_weight= '%@'  where id = '%@' and user_profile_id='%@'",cals,weight,meal_ID,userProfileID];
        }
        else
        {
        sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set cals ='%@' ,item_weight= '%@',log_time='%@'  where id = '%@' and user_profile_id='%@'",cals,weight,date,meal_ID,userProfileID];
        }
        NSLog(@"sqlquery=%@",sqlQry);
        is_success=[[DbController mDBHandler] executeUpdate:sqlQry];
        [[DbController mDBHandler] commit];
    }
    
}

-(void)updateCalLog:(NSString*)cals foodID:(NSString *)meal_ID  withUserProfileID:(NSString *)userProfileID{
    BOOL is_success;
     if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set cals ='%@' where id = '%@' and user_profile_id='%@'",cals,meal_ID,userProfileID];
        is_success=[[DbController mDBHandler] executeUpdate:sqlQry];
          [[DbController mDBHandler] commit];
    }
 
}
-(int)getMaxFoodID:(NSString *)withUserProfileID {
    int maxRowId;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select id from fitmi_food_log where user_profile_id='%@' ORDER BY id DESC LIMIT 1",withUserProfileID];
        NSLog(@"sqlQry==%@",sqlQry);
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            maxRowId=[rs intForColumn:@"id"] ;
        }
       
        [[DbController mDBHandler] commit];
    }
    return maxRowId;

}

-(NSMutableDictionary*)getSingleFoodLogDetails :(NSString*)selectedFoodId
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log  where id='%@'",selectedFoodId];
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
             }
        [[DbController mDBHandler] commit];
    }
    
    return dic;
 }

-(NSMutableArray*)getUniqueRecentDate:(NSString *)userProfileID withMealID:(NSString*)selectedMealId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        if([selectedMealId isEqualToString: @"" ])
        {
        sqlQry = [NSString stringWithFormat:@"SELECT log_time  FROM fitmi_food_log where user_profile_id='%@' GROUP BY DATE(log_time) ORDER BY log_time DESC LIMIT 5",userProfileID];
        }
        else
        {
         sqlQry = [NSString stringWithFormat:@"SELECT log_time  FROM fitmi_food_log where meal_id='%@' AND user_profile_id='%@' GROUP BY DATE(log_time) ORDER BY log_time DESC LIMIT 5",selectedMealId,userProfileID];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSString *uniqueDate=[NSString stringWithFormat:@"%@",[[[rs stringForColumn:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]];
               [arr addObject:uniqueDate];
          }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
}

-(NSMutableArray*)getUniqueFavDate:(NSString *)userProfileID withMealID:(NSString*)selectedMealId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
         if([selectedMealId isEqualToString: @"" ])
         {
        sqlQry = [NSString stringWithFormat:@"SELECT log_time  FROM fitmi_food_log where user_profile_id='%@' AND isFavMeal=1 GROUP BY DATE(log_time) ORDER BY log_time DESC",userProfileID];
         }
        else
        {
        sqlQry = [NSString stringWithFormat:@"SELECT log_time  FROM fitmi_food_log where meal_id='%@' AND user_profile_id='%@' AND isFavMeal=1 GROUP BY DATE(log_time) ORDER BY log_time DESC",selectedMealId,userProfileID];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSString *uniqueDate=[NSString stringWithFormat:@"%@",[[[rs stringForColumn:@"log_time"] componentsSeparatedByString:@" "]objectAtIndex:0]];
            [arr addObject:uniqueDate];
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
}

-(NSMutableArray*)getRecentMealFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        if([selectedId isEqualToString: @"" ]){
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where  user_profile_id='%@' AND log_time between '%@ 00:00:01' AND '%@ 23:59:59' group by reference_food_id",selectedUserId,selectedDate,selectedDate];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id='%@' AND user_profile_id='%@' AND log_time between '%@ 00:00:01' AND '%@ 23:59:59' group by reference_food_id",selectedId,selectedUserId,selectedDate,selectedDate];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

-(NSMutableArray*)getFavMealFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        if([selectedId isEqualToString: @"" ]){
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where  user_profile_id='%@' AND log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND isFavMeal=1 group by reference_food_id",selectedUserId,selectedDate,selectedDate];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_food_log where meal_id='%@' AND user_profile_id='%@' AND log_time between '%@ 00:00:01' AND '%@ 23:59:59' AND isFavMeal=1 group by reference_food_id",selectedId,selectedUserId,selectedDate,selectedDate];
        }
        ResultSet *rs=[[DbController mDBHandler] executeQuery:sqlQry];
        while ([rs next]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]] forKey:@"id"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"meal_id"]] forKey:@"meal_id"];
            [dic setValue:[rs stringForColumn:@"food_name"] forKey:@"food_name"];
            [dic setValue:[rs stringForColumn:@"description"] forKey:@"item_desc"];
            [dic setValue:[rs stringForColumn:@"cals"] forKey:@"cals"];
            [dic setValue:[rs stringForColumn:@"serving_size"] forKey:@"serving_size"];
            [dic setValue:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setValue:[rs stringForColumn:@"item_weight"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"gm_calorie"];
            [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavorite"]] forKey:@"isFavorite"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
             [dic setValue:[NSString stringWithFormat:@"%d",[rs intForColumn:@"isFavMeal"]] forKey:@"isFavMeal"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

-(void)updateWeightLog:(NSString*)weight withCalVal:(NSString*)cal foodID:(NSString *)meal_ID  withUserProfileID:(NSString *)userProfileID{
    BOOL is_success;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry = [NSString stringWithFormat:@"update fitmi_food_log set item_weight ='%@',cals ='%@' where id = '%@' and user_profile_id='%@'",weight,cal,meal_ID,userProfileID];
        is_success=[[DbController mDBHandler] executeUpdate:sqlQry];
        [[DbController mDBHandler] commit];
    }
    
}

@end
