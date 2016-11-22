//
//  DbController.h
//  TradeForm
//
//  Created by Biswabaran on 15/07/11.
// Copyright (c) 2011 Ethertricity Limited. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "DbHandler.h"

@interface DbController : NSObject
{
    
}

+(void)OpenDatabase;
+(void)SetDatabaseName:(NSString*)str_DataBaseName;
+(DbHandler*)mDBHandler;
+(void) setCCCDatabase:(DbHandler *)database;

@end