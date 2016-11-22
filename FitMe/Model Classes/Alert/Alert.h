
/********************************************//*!
* @file Alert.h
* @brief Contains constants and global parameters
* DreamzTech Solution ("COMPANY") CONFIDENTIAL
* Unpublished Copyright (c) 2015 DreamzTech Solution, All Rights Reserved.
***********************************************/


#import <Foundation/Foundation.h>

@interface Alert : NSObject
//#define BASE_URL @"http://fitmi-dev.cloudapp.net/fitmi/v1/authentication"
#define BASE_URL @"https://danielahorowitz.com/projects/fitmi/api_c/v0000001/authentication"
//#define CONNECTION_URL @"http://danielahorowitz.com/projects/fitmi/api_c/v0000001"
#define ACCESS_KEY_URL @"https://danielahorowitz.com/projects/fitmi/api_c/v0000001/authentication/login/access_key"
#define API_KEY @"123456"
#define ALERT_TITLE @"FitMi"

#define SaveUser @"SaveUser"
#define SaveProfile @"SaveProfile"
#define CARTCOUNT @"CartCount"

#pragma mark- USER LOGIN

#define UserNameCheck @"Username cannot be left blank."
#define UserNamePasswordCheck @"Username and Password cannot be left blank."
#define PasswordCheck @"Please enter password."
#define EMAILID_VALIDATION @"Please enter valid email id."
#define ENTER_VALID_PASSWORD @"Your password must be at least 8 characters long and must include at least one uppercase letter and at least one number."
#define FIELD_SHOULD_NOT_BLANK @" is mandatory field."
#define PASSWORD_MATCH @"Password should match with confirm password field."
#define FIELD_SHOULDNOT_ALPHABET @" does not support special character."
#define VALIDATIONCODE_MISMATCH @"Invalid Verification Code."
#define INTERNET_CONNNECTION @"No Internet connection available."
#define PASSWORD_CHARACTER @" should be minimum 7 character."
#define INVALID_PASSWORD @" only allow letters and numbers."

#define  TAB_COLOR [UIColor colorWithRed:41.0f/255.0f green:41.0f/255.0 blue:41.0f/255.0f alpha:1.0f]
#define  TAB_SELECTED_COLOR [UIColor colorWithRed:209.0f/255.0f green:54.0f/255.0 blue:67.0f/255.0f alpha:1.0f]
#define VALIDATION_CTRL [Validation sharedManager]

#pragma mark- Device Height
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@end
