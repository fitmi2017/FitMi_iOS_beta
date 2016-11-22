//
//  WeightLog.h
//  FitMe
//
//  Created by Debasish on 23/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface WeightLog : NSObject
@property(nonatomic,strong)NSString *log_user_id;
@property(nonatomic,strong)NSString *log_bp_id;
@property(nonatomic,strong)NSString *log_user_profile_id;
@property(nonatomic,strong)NSString *weightVal;
@property(nonatomic,strong)NSString *log_log_time;
@property(nonatomic,strong)NSString *log_date_added;

-(void)saveUserWeightDataLog;
-(NSMutableArray*)getAllWeightDataLog:(NSString *)fromDate toDate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)updateWeightData:(NSString *)weightID withWeightVal:(NSString *)strWeightVal;
-(BOOL)deleteWeightData:(NSString *)weightID;
-(int)getWeight:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
@end
