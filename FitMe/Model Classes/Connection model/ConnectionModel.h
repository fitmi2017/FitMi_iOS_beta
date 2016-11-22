//
//  Connection Model.h
//  Ugo jersey
//
//  Created by Debasish Pal on 09/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol connectionDidReceiveResponse <NSObject>
@required
-(void)connectionDidReceiveResponse:(ASIHTTPRequest*)response;
-(void)connectionDidFailedResponse:(ASIHTTPRequest*)response;
@end

@interface ConnectionModel : NSObject
{
    ASIFormDataRequest *request;
    id <connectionDidReceiveResponse>delegate;
}
@property (nonatomic, strong) id <connectionDidReceiveResponse>delegate;
@property (nonatomic, strong)ASIFormDataRequest *request;

-(void)startResquestForLogin:(NSMutableDictionary*)dict;
-(void)startResquestForLogout:(NSMutableDictionary*)dict;

@end
