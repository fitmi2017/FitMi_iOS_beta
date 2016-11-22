//
//  ServerConnection.h
//  FuseD
//
//  Created by Shaun on 2/17/15.
//  Copyright (c) 2015 Shaun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Utility.h"
#import "Constant.h"
@protocol ServerConnectionDelegate <NSObject>

-(void)requestDidFinished:(id)result;

@end
@interface ServerConnection : NSObject<ASIHTTPRequestDelegate>
{
    id <ServerConnectionDelegate> delegate;
    LoginAction mLoginAction;
}
@property (nonatomic, strong)  id <ServerConnectionDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;

+ (instancetype)sharedInstance;
-(void)initialConnection;
-(void)logout:(NSString *)userAccessKey;
-(void)login:(NSString *)emailid Password:(NSString *)_password;
-(void)signup:(NSString *)first_name Lastname:(NSString *)last_name EmailId:(NSString *)email_address Password:(NSString *)password;
-(void)forgetPassword:(NSString *)emailid;
-(void)saveProfile:(NSString*)jsonStr userID:(NSString*)userID AccessKey:(NSString*)userAccessKey;
-(void)saveProfilePrevious:(NSString*)height_ft Height:(NSString*)height_inch FirstName:(NSString*)firstNm LastName:(NSString*)lastNm DateofBirth:(NSString*)dob ActivityLevel:(NSString*)actLevel DailyCalIntake:(NSString*)dailyCalIntake Weight:(NSString*)weightVal  WeightUnit:(NSString*)weightUnit Gender:(NSString*)genderVal AccessKey:(NSString*)userAccessKey userID:(NSString*)userID;
-(void)getHomeData:(NSString *)userAccessKey Timestamp:(NSString *)timestamp;
-(void)searchFoodLog:(NSString*)searchString;
-(void)searchFoodBarLog:(NSString*)searchString;
-(void)searchActivityLog:(NSString*)searchString;
-(void)getProfile:(NSString*)userID AccessKey:(NSString*)userAccessKey;
-(void)saveSyncLog:(NSString*)jsonStr userID:(NSString*)userID AccessKey:(NSString*)userAccessKey;
-(void)saveProfileImage:(NSString*)userID AccessKey:(NSString*)userAccessKey ImageData:(NSData*)imageData;
-(void)getProfileImage:(NSString*)userID AccessKey:(NSString*)userAccessKey;
@end
