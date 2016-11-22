//
//  DeviceLog.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 27/11/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"


@interface DeviceLog : NSObject

@property(nonatomic,strong)NSString *log_user_id;
@property(nonatomic,strong)NSString *log_id;
@property(nonatomic,strong)NSString *log_user_profile_id;
@property(nonatomic,strong)NSString *deviceType;
@property(nonatomic,strong)NSString *deviceStatus;
@property(nonatomic,strong)NSString *log_log_time;
@property(nonatomic,strong)NSString *log_date_added;

-(void)saveUserDeviceDataLog;
-(NSMutableArray*)getAllDeviceDataLog:(NSString *)logDate withUserProfileID:(NSString *)userProfileID;

-(BOOL)updateDeviceData:(NSString *)deviceType withStatusVal:(NSString *)strStatusVal   
 withLogDate:(NSString *)logDate withUserProfileID:(NSString *)userProfileID;
@end
