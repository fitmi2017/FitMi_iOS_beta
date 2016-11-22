//
//  Constant.h
//  BubbleBing
//
//  Created by Debasish Pal on 25/05/12.
//  Copyright (c) 2012 ObjectSol Technologies. All rights reserved.
//

//New: http://fitmi-dev.cloudapp.net/fitmi/v1/
//Old: https://danielahorowitz.com/projects/fitmi/api_c/v0000001/

//For Final
#define BASE_URL_CLIENT @"https://fitmi.mobi/v1/authentication"
#define BASE_URL @"http://59.162.181.91/portfolio/fitmiwebservice/index.php/authentication"

//#define BASE_URL @"https://danielahorowitz.com/projects/fitmi/api_c/v0000001/authentication"


#define CONNECTION_URL @"https://danielahorowitz.com/projects/fitmi/api_c/v0000001"

//#define SYNC_CONNECTION_URL @"https://fitmi.mobi/v1/sync/put"
#define SYNC_CONNECTION_URL @"http://59.162.181.91/portfolio/fitmiwebservice/index.php/sync/put"

#define ACCESS_KEY_URL @"https://danielahorowitz.com/projects/fitmi/api_c/v0000001/authentication/login/access_key"
#define API_KEY @"123456"
#define ALERT_TITLE @"FitMi"

#define SaveUser @"SaveUser"
#define CARTCOUNT @"CartCount"

#define BASE_HOST_URL @"http://localdev.mtc.com/"
#define BASE_URL_2 @"/crmappservice.aspx"

#define App_Delegate_Instance (AppDelegate *)[[UIApplication sharedApplication]delegate]
#define User_Defaults [NSUserDefaults standardUserDefaults]

#define ConnectionUnavailable @"The Internet Connection appears to be Offline.Please Try again later."
//#define ConnectionSlow @"The Internet Connection appears to be very slow.Please Try again later."
#define ConnectionSlow @"This is not responding right now. Please try again after somewhile."

#define TimeStamp [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
