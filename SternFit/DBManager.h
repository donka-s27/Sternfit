//
//  DBManager.h
//  CourseSaver
//
//  Created by MacOS on 8/6/14.
//  Copyright (c) 2014 com.avramov.coursesaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
- (NSArray*) getMessages:(NSString *) chatroomID limit:(int)limit;
- (BOOL) deleteMessages:(NSString*) chatroomID;
- (BOOL) addMessage:(NSString*)chatroomID
           senderID:(NSString*)senderID message:(NSString*)message type:(NSString*)type lastupdatetime:(NSString*)lastupdatetime created_at:(NSString*)created_at updated_at:(NSString*) updated_at status:(NSString*) status;
- (BOOL) updateMessage:(NSString *)chatroomID;
- (NSString*) getLastUpdateTime:(NSString *) chatroomID;
- (NSArray*) getLastUnreadMessage:(NSString *) chatroomID;
- (int) getLastUnreadMessageNum:(NSString *) chatroomID;

@end