//
//  UnitsLog.h
//  FitMe
//
//  Created by Debasish on 23/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface UnitsLog : NSObject

@property(nonatomic,strong)NSString *unitlog_user_id;
@property(nonatomic,strong)NSString *unitlog_user_profile_id;
@property(nonatomic,strong)NSString *unit_id;
@property(nonatomic,strong)NSString *unit_type;

-(void)saveUserUnitDataLog;
-(NSMutableArray*)getAllUnitDataLog:(NSString *)userProfileID;
-(NSString *)getUnitTypeID:(NSString *)unitType withUnitCategory:(NSString *)unitCat;
-(NSString *)getUnitType:(NSString *)unitTypeID withUnitCategory:(NSString *)unitCat;
-(NSString *)getselectedUnitTypeID:(NSString *)unitType withUserID:(NSString *)userID withUserProfileID:(NSString *)userProfileID;
-(BOOL)updateUserUnitDataLog:(NSString *)unitType;
@end
