//
//  FavFoodLog.m
//  FitMe
//
//  Created by Debasish on 27/01/16.
//  Copyright (c) 2016 Dreamztech Solutions. All rights reserved.
//

#import "FavFoodLog.h"
#import "Utility.h"

@implementation FavFoodLog

-(void)saveFavFoodDataLog:(NSMutableDictionary*)dictFood withFoodID:(NSString *)foodID withLogUserID:(NSString *)logUserID withUserProfileID:(NSString *)profileUserID{
    NSLog(@"dictFood=%@",dictFood);
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"insert into fitmi_fav_food_log (id,user_id,user_profile_id,meal_id,food_name,description,cals,serving_size, reference_food_id,log_time,date_added,gm_calorie) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",foodID,logUserID,profileUserID,self.log_meal_id,self.log_item_title,self.log_item_desc,self.log_cals,self.log_serving_size,self.log_reference_food_id,self.log_log_time,self.log_date_added,self.log_item_weight];
        [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
    }
    
    
}
-(BOOL)deleteFavFoodData:(NSString *)foodId withUserId:(NSString *)userId{
    BOOL isSuccess;
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        
        NSString *sqlQry=[NSString stringWithFormat:@"delete from fitmi_fav_food_log  where  id='%@'",foodId];
        isSuccess=  [[DbController mDBHandler] executeUpdate:sqlQry];
        
        [[DbController mDBHandler] commit];
        
    }
    
    return isSuccess;
    
}
-(NSMutableArray*)getAllFavoriteFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId{
    
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sqlQry;
    
    if (![DbController mDBHandler].inUse) {
        [[DbController mDBHandler] beginTransaction];
        if([selectedId isEqualToString: @"" ]){
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_fav_food_log where  user_profile_id='%@'  group by reference_food_id",selectedUserId];
        }
        else{
            sqlQry = [NSString stringWithFormat:@"select * from fitmi_fav_food_log where meal_id='%@' AND user_profile_id='%@'  group by reference_food_id",selectedId,selectedUserId];
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
            [dic setValue:[rs stringForColumn:@"gm_calorie"] forKey:@"item_weight"];
            [dic setValue:[rs stringForColumn:@"reference_food_id"] forKey:@"item"];
            [dic setValue:[rs stringForColumn:@"log_time"] forKey:@"log_time"];
            
            [arr addObject:dic];
            
        }
        [[DbController mDBHandler] commit];
    }
    
    return arr;
    
    
}

@end
