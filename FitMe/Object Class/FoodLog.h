//
//  FoodLog.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 15/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface FoodLog : NSObject
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
@property(nonatomic,strong)NSString *log_gm_cal;
-(void)saveUserFoodDataLog;
-(void)saveUserFavFoodDataLog;
-(NSMutableArray*)getAllFoodLog :(NSString*)selectedUserId;
-(NSMutableArray*)getAllBreakfastLog;
-(NSMutableArray*)getAllLunchLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;
-(NSMutableArray*)getAllDinnerLog;
-(NSMutableArray*)getAllSnackLog;
-(int)getFoodSumCalorie:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
-(int)getFoodSumIndividualCalorieFav:(NSString *)mealID withUserProfileID:(NSString *)userProfileID withDate:(NSString *)date;
-(NSMutableArray*)getAllFavoriteFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;
-(int)getFoodSumIndividualCalorie:(NSString *)mealID withUserProfileID:(NSString *)userProfileID withDate:(NSString *)date;
-(BOOL)deleteUserFoodDataLog:(NSString *)mealId withSelectedDate:(NSString *)selectedDate withSelecteduser_id:(NSString *)selectedUserId;
-(BOOL)getDailyFoodLog:(NSString *)mealTypeId withSelectedDate: (NSString *)selectedDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)deleteRowFoodData:(NSString *)mealId withSelectedDate:(NSString *)selectedDate withUserId:(NSString *)userId;
-(void)updateCalLog:(NSString*)cals foodID:(NSString *)meal_ID withUserProfileID:(NSString *)userProfileID;
-(void)updateFavoriteStatus:(NSString*)FavStatus foodID:(NSString *)food_ID  withUserProfileID:(NSString *)userProfileID withFoodRefID:(NSString *)food_Ref_ID;
-(void)updateMealFavoriteStatus:(NSString*)FavStatus foodID:(NSString *)food_ID  withUserProfileID:(NSString *)userProfileID withMealFavStatus:(NSString*)MealFavStatus withFoodRefID:(NSString *)food_Ref_ID;
-(void)updateGramLog:(NSString*)cals withWeight:(NSString*)weight withDate:(NSString*)date foodID:(NSString *)meal_ID  withUserProfileID:(NSString *)userProfileID;
-(int)getMaxFoodID:(NSString *)withUserProfileID ;
-(BOOL)findID:(NSString *)selectedID withUserProfileID:userProfileID withmeal_id:(NSString *)meal_id withSelectedDate:(NSString*)selectedDate;

-(NSMutableDictionary*)getSingleFoodLogDetails :(NSString*)selectedFoodId;

-(NSMutableArray*)getAllRefID:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;
-(int)getFoodSumIndividualCalorieRecent:(NSString *)mealID withUserProfileID:(NSString *)userProfileID withDate:(NSString *)date;

-(NSMutableArray*)getAllRecentFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;

-(NSMutableArray*)getUniqueRecentDate:(NSString *)userProfileID withMealID:(NSString*)selectedMealId;
-(NSMutableArray*)getUniqueFavDate:(NSString *)userProfileID withMealID:(NSString*)selectedMealId;
-(NSMutableArray*)getRecentMealFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;
-(NSMutableArray*)getFavMealFoodLog:(NSString*)selectedId withSelectedDate:(NSString *)selectedDate withUserId:(NSString*)selectedUserId;
-(void)updateWeightLog:(NSString*)weight withCalVal:(NSString*)cal foodID:(NSString *)meal_ID  withUserProfileID:(NSString *)userProfileID;
-(NSMutableArray*)getAllFoodLogForSync :(NSString*)selectedUserId;
@end
