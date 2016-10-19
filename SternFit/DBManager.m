//
//  DBManager.m
//  CourseSaver
//
//  Created by MacOS on 8/6/14.
//  Copyright (c) 2014 com.avramov.coursesaver All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"quiz.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists chatrooms (ID text, name text, owner text, created_at text, updated_at text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sql_stmt = "create table if not exists chatmembers (chatroomID text, userID text, created_at text, updated_at text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sql_stmt = "create table if not exists messages (chatroomID text, senderID text, message text, type text, lastupdatetime text, created_at text, updated_at text, status text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) addMessage:(NSString*)chatroomID
           senderID:(NSString*)senderID message:(NSString*)message type:(NSString*)type lastupdatetime:(NSString*)lastupdatetime created_at:(NSString*)created_at updated_at:(NSString*) updated_at status:(NSString *)status;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into messages (chatroomID, senderID, message, type, lastupdatetime, created_at, updated_at, status) values (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", chatroomID, senderID, message, type, lastupdatetime, created_at, updated_at, status];
        //NSLog(@"%@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            return YES;
        } else {
            NSLog(@"SUDDEN NO");
            sqlite3_close(database);
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
    
}

- (BOOL) deleteMessages:(NSString*) chatroomID
{
    NSString *lastupdatetime = [self getLastUpdateTime:chatroomID];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"update messages set status=\"2\" where chatroomID = \"%@\" and lastupdatetime=\"%@\"", chatroomID, lastupdatetime];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
        }
        else {
            sqlite3_close(database);
        }
        sqlite3_reset(statement);
    }
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from messages where chatroomID=\"%@\" and (status=\"0\" or status=\"1\")", chatroomID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            return YES;
        }
        else {
            sqlite3_close(database);
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSArray*) getMessages:(NSString *) chatroomID limit:(int)limit
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from messages where chatroomID=\"%@\" and (status=\"0\" or status=\"1\") order by lastupdatetime desc limit %d", chatroomID, limit];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSString *senderID = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 1)];
                [dict setObject:senderID forKey:@"senderID"];
                NSString *message = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 2)];
                [dict setObject:message forKey:@"message"];
                NSString *type = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 3)];
                [dict setObject:type forKey:@"type"];
                NSString *lastupdatetime = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                [dict setObject:lastupdatetime forKey:@"lastupdatetime"];
                NSString *created_at = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 5)];
                [dict setObject:created_at forKey:@"created_at"];
                [resultArray addObject:dict];
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            [self updateMessage:chatroomID];
            
            int j = 0;
            for(int i = 0; i < [resultArray count] / 2; i++) {
                j = (int) [resultArray count] - i - 1;
                
                [resultArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
            return resultArray;
        }
    }
    return nil;
}

- (NSString*) getLastUpdateTime:(NSString *) chatroomID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select lastupdatetime from messages where chatroomID=\"%@\" order by lastupdatetime desc limit 1", chatroomID];
        const char *query_stmt = [querySQL UTF8String];
        NSString *lastupdatetime = @"0";
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                lastupdatetime = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 0)];
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            return lastupdatetime;
        }
    }
    return @"0";
}

- (NSArray*) getLastUnreadMessage:(NSString *) chatroomID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from messages where chatroomID=\"%@\" and (status=\"0\" or status=\"1\") order by lastupdatetime desc limit 1", chatroomID];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSString *senderID = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                [dict setObject:senderID forKey:@"senderID"];
                NSString *message = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 2)];
                [dict setObject:message forKey:@"message"];
                NSString *type = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 3)];
                [dict setObject:type forKey:@"type"];
                NSString *lastupdatetime = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 4)];
                [dict setObject:lastupdatetime forKey:@"lastupdatetime"];
                NSString *created_at = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 5)];
                [dict setObject:created_at forKey:@"created_at"];
                [resultArray addObject:dict];
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            return resultArray;
        }
    }
    return nil;
}

- (int) getLastUnreadMessageNum:(NSString *) chatroomID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select count(*) from messages where chatroomID=\"%@\" and status=\"0\"", chatroomID];
        const char *query_stmt = [querySQL UTF8String];
        int num = 0;
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *count = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                num = [count intValue];
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            return num;
        }
    }
    return 0;
}

- (BOOL) updateMessage:(NSString *)chatroomID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"update messages set status=\"1\" where chatroomID = \"%@\" and status=\"0\"", chatroomID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            return YES;
        }
        else {
            sqlite3_close(database);
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}


@end
