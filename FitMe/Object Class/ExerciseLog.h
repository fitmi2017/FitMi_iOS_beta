//
//  ExerciseLog.h
//  FitMe
//
//  Created by Debasish on 17/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"

@interface ExerciseLog : NSObject
@property(nonatomic,strong)NSString *log_user_id;
@property(nonatomic,strong)NSString *log_user_profile_id;
@property(nonatomic,strong)NSString *log_exercise_id;
@property(nonatomic,strong)NSString *log_item_title;
@property(nonatomic,strong)NSString *log_cals;
@property(nonatomic,strong)NSString *log_item_desc;
@property(nonatomic,strong)NSString *log_total_time;
@property(nonatomic,strong)NSString *log_log_time;
@property(nonatomic,strong)NSString *log_date_added;

-(void)saveUserExerciseDataLog;
-(int)getActivitySumBurned:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
-(int)getFoodSumIndividualCalorie:(NSString *)exerciseID withUserProfileID:(NSString *)userProfileID  withDate:selectedDate;
-(int)getFoodSumAllCalorie:(NSString *)exerciseID withUserProfileID:(NSString *)userProfileID withDate:selectedDate;
-(NSMutableArray*)getAllActivityLog:(NSString *)fromDate toDate:(NSString *)toDate withSelectedUserID:(NSString* )userProfileID;
-(NSMutableArray*)getParticularActivityLog:(NSString *)fromDate toDate:(NSString *)toDate withSelectedUserID:(NSString* )userProfileID withActivityTypeID:(NSString *)activityTypeID;
-(NSMutableArray*)getMyActivityLog:(NSString* )userProfileID;
-(BOOL)updateActivityTime:(NSString *)activityID withTimeVal:(NSString *)strTimeVal withTotalCalVal:(NSString *)strTotalCal;
-(BOOL)deleteActivityData:(NSString *)activityID;
-(BOOL)getDailyExerciseLog:(NSString *)exerciseTypeId withSelectedDate:(NSString *)selectedDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)deleteUserExerciseDataLog:(NSString *)exerciseId withSelectedDate:(NSString *)selectedDate withSelecteduser_id:(NSString *)selectedUserId;
-(BOOL)getDeviceExerciseLog:(NSString *)exerciseName withSelectedDate:(NSString *)selectedDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)updateUserExerciseDataLog:(NSString *)activityNm andLogTime:(NSString *)strTimeVal withCalorieVal:(NSString *)strTotalCal withUserProfileID:(NSString *)userProfileID;
@end
