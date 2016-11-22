//
//  FavMealLog.h
//  FitMe
//
//  Created by Debasish on 27/01/16.
//  Copyright (c) 2016 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"

@interface FavMealLog : NSObject

@property(nonatomic,strong)NSString *log_user_id;
@property(nonatomic,strong)NSString *log_user_profile_id;
@property(nonatomic,strong)NSString *log_meal_id;
@property(nonatomic,strong)NSString *log_item_title;
@property(nonatomic,strong)NSString *log_cals;
@property(nonatomic,strong)NSString *log_item_desc;
@property(nonatomic,strong)NSString *log_serving_size;
@property(nonatomic,strong)NSString *log_reference_food_id;//liv_strong_id
@property(nonatomic,strong)NSString *log_log_time;
@property(nonatomic,strong)NSString *log_date_added;
@property(nonatomic,strong)NSString *log_item_weight;
-(void)saveFavMealDataLog:(NSMutableDictionary*)dictMealFood withFoodID:(NSString *)foodID withLogUserID:(NSString *)logUserID withUserProfileID:(NSString *)profileUserID;
-(BOOL)deleteFavMealData:(NSString *)foodId withUserId:(NSString *)userId;
-(NSMutableArray*)getUniqueFavDate:(NSString *)userProfileID withMealID:(NSString*)selectedMealId;
-(NSMutableArray*)getFavMealFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;
@end
