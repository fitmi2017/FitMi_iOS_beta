//
//  UserProfileDetails.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 10/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface UserProfileDetails : NSObject
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *user_profile_id;
@property(nonatomic,strong)NSString *full_name;
@property(nonatomic,strong)NSString *first_name;
@property(nonatomic,strong)NSString *last_name;
@property(nonatomic,strong)NSString *height_ft;
@property(nonatomic,strong)NSString *height_in;
@property(nonatomic,strong)NSString *weight;
@property(nonatomic,strong)NSString *dob;
@property(nonatomic,strong)NSString *age;
@property(nonatomic,strong)NSString *activity_level;
@property(nonatomic,strong)NSString *daily_calorie_intake;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,strong)NSString *image_path;
@property(nonatomic,strong)NSString *cal_intake_status;

-(int)saveUserProfileDetails;
-(NSMutableArray*)getUserProfileList;
-(NSMutableArray*)getUserProfileDetails:(NSString *)userProfileID;
-(BOOL)updateUserProfileDetails:(NSString *)userProfileID;
-(BOOL)updateUserProfile:(NSString *)userProfileID withIntakeVal:(NSString *)strIntakeVal withColumnNm:(NSString *)strColumnNm;
-(BOOL)deleteUserData:(NSString *)userID;
-(BOOL)updateUserProfileImg:(int)userProfileID withImagePath:(NSString*)imgPath;
@end
