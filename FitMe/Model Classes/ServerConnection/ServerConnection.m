//
//  ServerConnection.m
//  FuseD
//
//  Created by Shaun on 2/17/15.
//  Copyright (c) 2015 Shaun. All rights reserved.
//

#import "ServerConnection.h"
#define APP_ID  @"b65138b3"

#define APP_KEY  @"220fa746203ea5217abff5970c9f8d43"

#define FOODSEARCH_URL @"https://api.nutritionix.com/v1_1/search"
#define FOODSEARCH_BAR_URL @"https://api.nutritionix.com/v1_1/item"
//#define FOODSEARCH_URL @"https://service.livestrong.com/service/food/foods/"
#define ACTIVITYSEARCH_URL @"https://service.livestrong.com/service/fitness/exercises/"

@implementation ServerConnection
@synthesize delegate;


+ (instancetype)sharedInstance
{
    static ServerConnection *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServerConnection alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Initial Connection

-(void)initialConnection{
    
    NSURL *url=[NSURL URLWithString:ACCESS_KEY_URL];
    
    NSData *postData = [ACCESS_KEY_URL dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
}

#pragma mark - Login API

-(void)login:(NSString *)emailid Password:(NSString *)_password{
    
    NSString *postString = [NSString stringWithFormat:@"email_address=%@&password=%@",[emailid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/login",BASE_URL]];
    NSLog(@"BASE_URL====%@",BASE_URL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
}

#pragma mark - Logout API

-(void)logout:(NSString *)userAccessKey{
   
 //   NSString *postString = [NSString stringWithFormat:@"logout=%@&access_token=%@&access_key=%@",@"1",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey];
    NSString *postString = [NSString stringWithFormat:@"logout=%@",@"1"];

    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/logout",BASE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
}

#pragma mark - GetHomeData API

-(void)getHomeData:(NSString *)userAccessKey Timestamp:(NSString *)timestamp{
    
  // NSString *postString = [NSString stringWithFormat:@"access_token=%@&access_key=%@",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey];
    NSString *postString = [NSString stringWithFormat:@"start_date=%@&end_date=%@&access_key=%@",timestamp,timestamp,userAccessKey];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/get/stats/general/home",CONNECTION_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
}

#pragma mark - Sign Up API

-(void)signup:(NSString *)first_name Lastname:(NSString *)last_name EmailId:(NSString *)email_address Password:(NSString *)password{

    /*NSString *postString = [NSString stringWithFormat:@"access_token=%@&first_name=%@&last_name=%@&email_address=%@&confirm_email_address=%@&password=%@&confirm_password=%@",@"fe32981fa08335a8ba36cd45f4ab505d",[first_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[last_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[email_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[email_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];*/
    
 
     NSString *postString = [NSString stringWithFormat:@"access_token=%@&email_address=%@&confirm_email_address=%@&password=%@&confirm_password=%@",@"fe32981fa08335a8ba36cd45f4ab505d",[email_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[email_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSLog(@"BASE_URL===========%@",[NSString stringWithFormat:@"%@/signup",BASE_URL]);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/signup",BASE_URL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
}

#pragma mark - Forget Password

-(void)forgetPassword:(NSString *)emailid{
    NSString *postString = [NSString stringWithFormat:@"email_address=%@",[emailid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/forgot_password",BASE_URL]];
    NSLog(@"forgot password%@",[NSString stringWithFormat:@"%@/forgot_password",BASE_URL]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
}

#pragma mark - Save Profile
-(void)saveProfile:(NSString*)jsonStr userID:(NSString*)userID AccessKey:(NSString*)userAccessKey
{
      NSString *postString = [NSString stringWithFormat:@"access_token=%@&access_key=%@&users_id=%@&json=%@",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey,[userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],jsonStr];
    
    NSLog(@"POST STRING ===%@",postString);
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SYNC_CONNECTION_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }

}


#pragma mark - Save SyncLog
-(void)saveSyncLog:(NSString*)jsonStr userID:(NSString*)userID AccessKey:(NSString*)userAccessKey
{
    NSString *postString = [NSString stringWithFormat:@"access_token=%@&access_key=%@&json=%@",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey,jsonStr];
    
    NSLog(@"POST STRING ===%@",postString);
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SYNC_CONNECTION_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
    
}



#pragma mark - Save Profile

-(void)saveProfilePrevious:(NSString*)height_ft Height:(NSString*)height_inch FirstName:(NSString*)firstNm LastName:(NSString*)lastNm DateofBirth:(NSString*)dob ActivityLevel:(NSString*)actLevel DailyCalIntake:(NSString*)dailyCalIntake Weight:(NSString*)weightVal  WeightUnit:(NSString*)weightUnit Gender:(NSString*)genderVal AccessKey:(NSString*)userAccessKey userID:(NSString*)userID
{
    NSString *postString = [NSString stringWithFormat:@"access_token=%@&access_key=%@&height_ft=%@&height_in=%@&date_of_birth=%@&activity_level=%@&daily_calorie_intake=%@&weight=%@&weight_units=%@&first_name=%@&last_name=%@&gender=%@",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey,[height_ft stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[height_inch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[dob stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[actLevel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[dailyCalIntake stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[weightVal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[weightUnit stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[firstNm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[lastNm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[genderVal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://fitmi.mobi/v1/put/user/save_profile"]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://59.162.181.91/portfolio/fitmiwebservice/index.php/put/user/save_profile"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
    
}

-(void)saveProfileImage:(NSString*)userID AccessKey:(NSString*)userAccessKey ImageData:(NSData*)imageData
{
        
   /* NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:imageData];
    
    NSURLConnection *conn =[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (conn) {
        _responseData =[NSMutableData new];
    }*/
}

-(void)getProfileImage:(NSString*)userID AccessKey:(NSString*)userAccessKey
{
    NSString *postString = [NSString stringWithFormat:@"access_token=%@&access_key=%@",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/image_profile",BASE_URL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
    
}

-(void)getProfile:(NSString*)userID AccessKey:(NSString*)userAccessKey
{
    NSString *postString = [NSString stringWithFormat:@"access_token=%@&access_key=%@&users_id=%@&username=%@",@"fe32981fa08335a8ba36cd45f4ab505d",userAccessKey,userID,@"dilip@gmail.com"];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://fitmi.mobi/v1/get/user/profile"]];
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://59.162.181.91/portfolio/fitmiwebservice/index.php/get/user/profile"]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.34/fitmiwebservice/index.php/get/user/profile"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }

}

-(void)searchFoodBarLog:(NSString*)searchString{
    
    NSString *postString = [NSString stringWithFormat:@"?upc=%@&appId=%@&appKey=%@",searchString,APP_ID,APP_KEY];
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",FOODSEARCH_BAR_URL,postString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
    
}

-(void)searchFoodLog:(NSString*)searchString{
    
    NSString *postString = [NSString stringWithFormat:@"/%@?fields=item_name,brand_name,nf_calories,nf_serving_size_qty,item_description,nf_serving_size_unit,nf_serving_weight_grams,nf_ingredient_statement&appId=%@&appKey=%@",searchString,APP_ID,APP_KEY];
    
  //  NSString *postString = [NSString stringWithFormat:@"/%@?results=%@&cal_min=0&cal_max=50000&fields=item_name,brand_name,nf_calories,nf_serving_size_qty,item_description,nf_serving_size_unit,nf_serving_weight_grams,nf_ingredient_statement&appId=%@&appKey=%@",searchString,@"0:20",APP_ID,APP_KEY];
    
    // NSString *postString = [NSString stringWithFormat:@"?query=%@&limit=5&fill=item,item_title,cals,serving_size,item_desc,images",searchString];
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",FOODSEARCH_URL,postString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
    
    
}


-(void)searchActivityLog:(NSString*)searchString{
    NSString *postString = [NSString stringWithFormat:@"?query=%@&limit=5&fill=fitness_id,exercise,description,cals_per_hour,images",searchString];
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",ACTIVITYSEARCH_URL,postString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        _responseData =[NSMutableData new];
    }
    
    
}


#pragma mark -
#pragma mark Connection Delegates

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [_responseData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(requestDidFinished:)]) {
        [self.delegate requestDidFinished:error];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receivedString = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    NSDictionary *dictresponse = [receivedString JSONValue];
    NSLog(@"RESPONSE=========\n%@\n=============",dictresponse);
    
    if ([self.delegate respondsToSelector:@selector(requestDidFinished:)]) {
        [self.delegate requestDidFinished:dictresponse];
    }
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = [NSURL URLWithString:CONNECTION_URL];
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark End of Connection Delegates

@end
