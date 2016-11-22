//
//  Connection Model.m
//  Ugo jersey
//
//  Created by Debasish Pal on 09/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "ConnectionModel.h"
#import "Constant.h"

@implementation ConnectionModel

@synthesize delegate,request;

-(ASIFormDataRequest*)initiateRequestWithURL:(NSURL*)url
{
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    [_request setUseKeychainPersistence:YES];
    [_request setTimeOutSeconds:60];
    [_request setDelegate:self];
    _request.shouldAttemptPersistentConnection   = NO;
    return _request;
}

#pragma mark - Login Webservice
-(void)startResquestForLogin:(NSMutableDictionary*)dict
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *strDomainNm=[defaults objectForKey:@"CustomDomain"];
    // NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@",BASE_URL];
    NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@%@%@",BASE_HOST_URL,strDomainNm,BASE_URL_2];
    
 /*   NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *strDomainNm=[defaults objectForKey:@"CustomDomain"];
   // NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@",BASE_URL];
    NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@/connector/crmappservice.aspx",strDomainNm];*/
    
    NSURL *url = [NSURL  URLWithString:[tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requrl: %@",url);
    
    self.request = [self initiateRequestWithURL:url];
  
    [self.request setPostValue:[dict objectForKey:@"op"] forKey:@"op"];
    [self.request setPostValue:[dict objectForKey:@"username"] forKey:@"username"];
    [self.request setPostValue:[dict objectForKey:@"password"] forKey:@"password"];
    [self.request setPostValue:[dict objectForKey:@"customdomain"] forKey:@"customdomain"];
    [self.request setPostValue:[dict objectForKey:@"token"] forKey:@"token"];
    
     [request setUsername:@"login"];
    [self.request startAsynchronous];
}
-(void)startResquestForLogout:(NSMutableDictionary*)dict
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *strDomainNm=[defaults objectForKey:@"CustomDomain"];
    // NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@",BASE_URL];
    NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@%@%@",BASE_HOST_URL,strDomainNm,BASE_URL_2];
    
    /*   NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
     NSString *strDomainNm=[defaults objectForKey:@"CustomDomain"];
     // NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@",BASE_URL];
     NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@/connector/crmappservice.aspx",strDomainNm];*/

    NSURL *url = [NSURL  URLWithString:[tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requrl: %@",url);
    
    self.request = [self initiateRequestWithURL:url];
    
    [self.request setPostValue:[dict objectForKey:@"op"] forKey:@"op"];
    [self.request setPostValue:[dict objectForKey:@"userid"] forKey:@"userid"];
    [self.request setPostValue:[dict objectForKey:@"deviceid"] forKey:@"deviceid"];
    [self.request setPostValue:[dict objectForKey:@"token"] forKey:@"token"];
    [self.request setPostValue:[dict objectForKey:@"devicetoken"] forKey:@"devicetoken"];
    
    [request setUsername:@"logout"];
    [self.request startAsynchronous];
}

#pragma mark - ASIFormDataRequest delegates
-(void)receivedData:(ASIHTTPRequest*) response
{
    NSLog(@"Received data");
}
- (void)requestFinished:(ASIHTTPRequest *)response
{
    [self.delegate connectionDidReceiveResponse:response];
    self.request = nil;
}
- (void)requestFailed:(ASIHTTPRequest *)response
{
    [self.delegate connectionDidFailedResponse:response];
    self.request = nil;
    
    NSLog(@"Connection failed");
}
@end

