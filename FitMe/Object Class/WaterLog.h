//
//  WaterLog.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 21/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface WaterLog : NSObject
@property(nonatomic,strong)NSString *waterlog_user_id;
@property(nonatomic,strong)NSString *waterlog_user_profile_id;
@property(nonatomic,strong)NSString *waterlog_quantity;
@property(nonatomic,strong)NSString *water_log_time;
@property(nonatomic,strong)NSString *waterlog_date_added;

-(void)saveUserWaterDataLog;
-(NSMutableArray*)getAllWaterLog:(NSString *)logDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)updateWaterData:(NSString *)waterID withWaterVal:(NSString *)strWaterVal;
-(float)getWaterSumBurned:(NSString *)fromDate  todate:(NSString *)toDate withUserProfileID:(NSString *)userProfileID;
-(BOOL)deleteWaterData:(NSString *)waterID;
@end
