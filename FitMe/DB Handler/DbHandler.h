//
//  DBHandeler.h
//  DBUtility
//
//  Created by Tamal on 24/11/10.
// Copyright (c) 2011 Ethertricity Limited. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "ResultSet.h"

@interface DbHandler : NSObject {
	sqlite3*    db;
	NSString*   databasePath;
    BOOL        logsErrors;
    BOOL        crashOnErrors;
    BOOL        inUse;
    BOOL        inTransaction;
    BOOL        traceExecution;
    BOOL        checkedOut;
    int         busyRetryTimeout;
    BOOL        shouldCacheStatements;
    NSMutableDictionary *cachedStatements;
}
+ (id)databaseWithPath:(NSString*)inPath;
- (id)initWithPath:(NSString*)inPath;

- (BOOL)open;
#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags;
#endif
- (BOOL)close;
- (BOOL)goodConnection;
- (void)clearCachedStatements;

// encryption methods.  You need to have purchased the sqlite encryption extensions for these to work.
- (BOOL)setKey:(NSString*)key;
- (BOOL)rekey:(NSString*)key;


- (int) saveProfileUser:(NSString *)query;
-(NSMutableArray *)getProfileUserList:(NSString *)query;
-(BOOL)updateTable:(NSString *)query;

-(NSMutableArray *)getUserCalorieList:(NSString *)query;

- (NSString *)databasePath;

- (NSString*)lastErrorMessage;

- (int)lastErrorCode;
- (BOOL)hadError;
- (sqlite_int64)lastInsertRowId;

- (sqlite3*)sqliteHandle;

- (BOOL)executeUpdate:(NSString*)sql, ...;
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray
					 :(NSArray*)arrayArgs orVAList
					 :(va_list)args; // you shouldn't ever need to call this.  use the previous two instead.

- (ResultSet *)executeQuery:(NSString*)sql, ...;
- (ResultSet *)executeQuery:(NSString *)sql withArgumentsInArray
						   :(NSArray *)arguments;
- (ResultSet *)executeQuery:(NSString *)sql withArgumentsInArray
						   :(NSArray*)arrayArgs orVAList
						   :(va_list)args; // you shouldn't ever need to call this.  use the previous two instead.

- (BOOL)rollback;
- (BOOL)commit;
- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;

- (BOOL)logsErrors;
- (void)setLogsErrors:(BOOL)flag;

- (BOOL)crashOnErrors;
- (void)setCrashOnErrors:(BOOL)flag;

- (BOOL)inUse;
- (void)setInUse:(BOOL)value;

- (BOOL)inTransaction;
- (void)setInTransaction:(BOOL)flag;

- (BOOL)traceExecution;
- (void)setTraceExecution:(BOOL)flag;

- (BOOL)checkedOut;
- (void)setCheckedOut:(BOOL)flag;

- (int)busyRetryTimeout;
- (void)setBusyRetryTimeout:(int)newBusyRetryTimeout;

- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;

- (NSMutableDictionary *)cachedStatements;
- (void)setCachedStatements:(NSMutableDictionary *)value;


+ (NSString*)sqliteLibVersion;

- (int)changes;

+(NSString*)GetDocumentDir;
+ (id)initWithDBName:(NSString*)aName;
+ (BOOL)FileExist:(NSString*)aPath;
+ (BOOL)CopyFile:(NSString*)Source Destination:(NSString*)Destination;
@end

@interface Statement : NSObject {
    sqlite3_stmt *statement;
    NSString *query;
    long useCount;
}

- (void)close;
- (void)reset;

- (sqlite3_stmt *)statement;
- (void)setStatement:(sqlite3_stmt *)value;

- (NSString *)query;
- (void)setQuery:(NSString *)value;

- (long)useCount;
- (void)setUseCount:(long)value;


@end
