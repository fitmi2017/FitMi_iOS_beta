//
//  UserProfile.h
//  FitMe
//
//  Created by Krishnendu Ghosh on 10/09/15.
//  Copyright (c) 2015 Dreamztech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@interface UserProfile : NSObject
@property(nonatomic,strong)NSString *fnameString;
@property(nonatomic,strong)NSString *lnameString;
@property(nonatomic,strong)NSString *emailString;
@property(nonatomic,strong)NSString *passwordString;
@property(nonatomic,strong)NSString *lastLginDateStr;
@property(nonatomic,strong)NSString *lastLogoutDateStr;
@property(nonatomic,strong)NSString *lastActiveDateStr;
@property(nonatomic,strong)NSString *dateCreatedStr;
@property(nonatomic,strong)NSString *dateModifiedStr;
@property(nonatomic,strong)NSString *userID;

-(void)saveUserData;
-(NSMutableArray *)loginCheck:(NSString *)emailStr password:(NSString *)pwdStr;
-(NSMutableArray *)getAllProfileID;
-(BOOL)updateUserPWD:(NSString *)userID withPasswordVal:(NSString *)strPassword;
-(NSString *)getPWD:(NSString *)userID;
@end
