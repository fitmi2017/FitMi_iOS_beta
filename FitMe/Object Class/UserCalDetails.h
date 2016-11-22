//
//  UserCalDetails.h
//  FitMe
//
//  Created by Debasish on 14/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"


@interface UserCalDetails : NSObject

@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *user_profile_id;
@property(nonatomic,strong)NSString *total_intake;
@property(nonatomic,strong)NSString *total_burned;
@property(nonatomic,strong)NSString *weight;
@property(nonatomic,strong)NSString *sleep;
@property(nonatomic,strong)NSString *water;
@property(nonatomic,strong)NSString *bp_sys;
@property(nonatomic,strong)NSString *bp_dia;

-(void)saveUserCalorieDetails;
-(BOOL)updateUserCalorieDetails:(NSString *)userProfileID;
-(BOOL)updateUserCalorie:(NSString *)userProfileID withIntakeVal:(NSString *)strIntakeVal withColumnNm:(NSString *)strColumnNm;
-(BOOL)updateUserBP:(NSString *)userProfileID withsysVal:(NSString *)strSysVal withdiaVal:(NSString *)strDiaVal;
-(NSMutableArray*)getUserCalorieDetails:(NSString *)userProfileID;
@end
