//
//  DbController.m
//  TradeForm
//
//  Created by Biswabaran on 15/07/11.
// Copyright (c) 2011 Ethertricity Limited. All Rights Reserved.
//

#import "DbController.h"
#import "sqlite3.h"
@implementation DbController

DbHandler *mDBHandler;

+(void) setCCCDatabase:(DbHandler *)database{
    mDBHandler = database;
}


+(void)OpenDatabase{
    @try {
        if ([mDBHandler open]) {
            [mDBHandler close];
            mDBHandler = nil;
        }
        mDBHandler = [DbHandler initWithDBName:@"Fitmi.sqlite"];
        
        if ([mDBHandler open] == NO) {
            [mDBHandler close];
        }
        //        else if ([SandboxDB open] == NO) {
        //   [SandboxDB close];
        //  }
        
        
#if DEBUG
        [mDBHandler setLogsErrors:YES];
#endif
    }
    @catch (NSException * e) {
        NSLog(@"%@",e);
    }
}

+(DbHandler*)mDBHandler{
    return mDBHandler;
}


+(void)SetDatabaseName:(NSString*)str_DataBaseName{
    @try {
        if ([mDBHandler open]) {
            [mDBHandler close];
            mDBHandler = nil;
        }
        mDBHandler = [DbHandler initWithDBName:str_DataBaseName];
        if ([mDBHandler open] == NO)
            [mDBHandler close];
#if DEBUG
        [mDBHandler setLogsErrors:YES];
#endif
    }
    @catch (NSException * e) {
        NSLog(@"exception=====%@",e);
    }
}
@end