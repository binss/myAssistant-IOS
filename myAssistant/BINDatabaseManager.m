//
//  BINDatabaseManager.m
//  myAssistant
//
//  Created by bin on 14/11/20.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDatabaseManager.h"
#import "AFNetworking.h"

@implementation BINDatabaseManager
@synthesize currentDate;
@synthesize currentRecord;

+ (BINDatabaseManager *)databaseManager
{
    static BINDatabaseManager *databaseManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        databaseManagerInstance = [[self alloc] init];
        [databaseManagerInstance connectDatabase];
    });
    return databaseManagerInstance;
}

- (void)connectDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"calendar.sqlite"];
    NSLog(@"%@",database_path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool existDatabase = YES;
    if ([fileManager fileExistsAtPath:database_path] == NO)
    {
        NSLog(@"数据库未创建");
        existDatabase = NO;
    }
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    else
    {
        // 如果数据库未创建，则创建表
        if(!existDatabase)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS RECORDS(id INTEGER PRIMARY KEY AUTOINCREMENT, year INTEGER, month INTEGER, day INTEGER, time TEXT, content TEXT, modify TEXT)";
            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                NSLog(@"创建表失败");
            }
            else
            {
                NSLog(@"创建表成功");
                
            }
        }
    }
}

- (NSMutableArray *)getMonthlyRecordIndex:(int)year withMonth:(int)month
{
    NSString *sql = [NSString stringWithFormat:@"SELECT day FROM RECORDS WHERE year = %i and month = %i and modify != 'D'", year, month];
    
    sqlite3_stmt *statement;
    
    NSMutableArray *activeDayList = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
//            int year = sqlite3_column_int(statement, 1);
//            int month = sqlite3_column_int(statement, 2);
//            int day = sqlite3_column_int(statement, 3);
            NSNumber *day = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
//            NSString *time = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//            NSString *content = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//            int modify = sqlite3_column_int(statement, 6);
//            NSLog(@"%@", content);
            [activeDayList addObject:day];
//            [calendarView setButtonColor:[UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1] dayIndex:day];
//            [calendarView setbuttonEnable:YES dayIndex:day];
        }
        sqlite3_finalize(statement);
    }

    return activeDayList;
}



- (NSMutableArray *)getDailyRecord
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    
    NSMutableArray *dayContentArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM RECORDS WHERE year = %i and month = %i and day = %i and modify != 'D'",[dateComponent year], [dateComponent month], [dateComponent day]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *time = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *content = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            [dayContentArray addObject:@{@"id":id, @"time":time,@"content":content}];
        }
        sqlite3_finalize(statement);
    }
    return dayContentArray;

}

- (NSArray *)getRecentRecord
{
//    NSString *recentDate = @"";
    NSArray * recentRecord;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];

    NSString *currentTime = [NSString stringWithFormat:@"%@:%@",[self checkTime:[dateComponent hour]], [self checkTime:[dateComponent minute]]];
//    NSLog(@"%@",currentTime);
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM RECORDS WHERE (year = %i and month = %i and day = %i and time >='%@' and modify != 'D') or (year > %i and modify != 'D') or (year = %i and month > %i and modify != 'D') or (year = %i and month = %i and day > %i and modify != 'D')  ORDER BY year, month, day, time",[dateComponent year], [dateComponent month], [dateComponent day], currentTime, [dateComponent year], [dateComponent year], [dateComponent month], [dateComponent year], [dateComponent month], [dateComponent day]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        // 只取第一行
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            int year = sqlite3_column_int(statement, 1);
            int month = sqlite3_column_int(statement, 2);
            int day = sqlite3_column_int(statement, 3);
            NSString *time = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *content = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            NSString *recentDate = [NSString stringWithFormat:@"%@-%@-%@ %@",[self checkTime:year], [self checkTime:month], [self checkTime:day], time];
            recentRecord = [NSArray arrayWithObjects:recentDate, content, nil];
        }
        sqlite3_finalize(statement);
    }
    return recentRecord;
}

- (void)createRecord:(NSString*)year withMonth:(NSString*)month withDay:(NSString*)day withTime:(NSString*)time withContent:(NSString*)content
{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO RECORDS (year, month, day, time, content, modify) VALUES ('%@', '%@', '%@', '%@','%@', 'A')",
                     year, month, day, time, content];
    char *errorMsg = NULL;
    //执行语句
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(db);
    }
}

- (void)modifyRecord:(NSString*)time withContent:(NSString*)content
{
    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE RECORDS SET time='%@', content='%@', modify='M' WHERE id='%@'",
                     time, content, [currentRecord objectForKey:@"id"]];
    NSLog(@"%@",sql);
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statment) == SQLITE_DONE)
        {
            NSLog(@"修改成功");
        }
    }
    
}

- (NSString *)checkTime:(int)time
{
    if (time < 10)
    {
        return [NSString stringWithFormat:@"0%i",time];
    }
    else
    {
        return [NSString stringWithFormat:@"%i",time];
    }
}

- (void)deleteRecord
{
//    NSString *sql = [NSString stringWithFormat:
//                     @"DELETE FROM RECORDS where id='%@'", [currentRecord objectForKey:@"id"]];
////    NSLog(@"%@",sql);
//    sqlite3_stmt *statment;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
//    {
//        if (sqlite3_step(statment) == SQLITE_DONE)
//        {
//            NSLog(@"删除成功");
//        }
//    }
    
    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE RECORDS SET modify='D' WHERE id='%@'", [currentRecord objectForKey:@"id"]];
    NSLog(@"%@",sql);
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statment) == SQLITE_DONE)
        {
            NSLog(@"修改成功");
        }
    }
}

- (void)synchrony
{
    // 选出有修改(A/D/M)的记录进行提交
    NSMutableArray *synchronyArray = [NSMutableArray array];
    NSMutableSet *localIndexList = [NSMutableSet set];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM RECORDS"];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *year = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *month = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *day = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *time = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *content = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            NSString *modify = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];

            if([modify isEqualToString:@"N"])
            {
                [localIndexList addObject:id];
            }
            else
            {
                [synchronyArray addObject:@{@"id":id, @"year":year, @"month":month, @"day":day, @"time":time,@"content":content, @"modify":modify}];
            }
            
        }
        sqlite3_finalize(statement);
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *synchronyDictionary = @{@"synchronyArray":synchronyArray};
    NSError *parseError;
    
    //NSDictionary转换为Data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:synchronyDictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    //Data转换为JSON
    NSString* str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
    
    NSDictionary *parameters = @{@"json":str};
    [manager POST:[@"http://127.0.0.1:8000/" stringByAppendingString:@"synchrony/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *state = [responseObject objectForKey:@"state"];
         if([state isEqual:@"1"])
         {
             NSLog(@"上传成功");
         }
         
         NSString *sql;
         char *errorMsg = NULL;
         sqlite3_stmt *statment;

         // 删除已上传记录
         sql = [NSString stringWithFormat:
                              @"DELETE FROM RECORDS where modify != 'N'"];
         if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) != SQLITE_OK)
         {
             sqlite3_close(db);
         }
         else
         {
             NSLog(@"STEP1 成功");
         }
         
         // 更新服务端更新的记录(插入/更新)
         for (NSDictionary *record in [responseObject objectForKey:@"synchronyList"])
         {
             NSString *sql = [NSString stringWithFormat:
                              @"INSERT OR REPLACE INTO RECORDS (id, year, month, day, time, content, modify) VALUES ('%@', '%@', '%@', '%@', '%@','%@', 'N')",
                              [record objectForKey:@"id"],[record objectForKey:@"year"], [record objectForKey:@"month"], [record objectForKey:@"day"], [record objectForKey:@"time"], [record objectForKey:@"content"]];
             if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                 sqlite3_close(db);
             }
         }
         NSLog(@"STEP2 成功");

    
         NSArray *allIndexList = [responseObject objectForKey:@"allIndexList"];
         // 删除服务端已不存在的记录
         if( [allIndexList count] > 0)
         {
             NSString *allIndexListString =  @"(";
             for (NSString *index in allIndexList)
             {
                 allIndexListString = [allIndexListString stringByAppendingFormat:@"'%@',",index];
             }
             
             allIndexListString = [allIndexListString substringToIndex:([allIndexListString length]-1)];
             allIndexListString = [allIndexListString stringByAppendingString:@")"];
//             NSLog(@"%@",allIndexListString);


             sql = [NSString stringWithFormat:@"DELETE FROM RECORDS WHERE id NOT in %@",allIndexListString];
            if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statment) == SQLITE_DONE)
                {
                    NSLog(@"STEP3 成功");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"同步成功！"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"同步失败，请检查网络"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
         [alert show];


         NSLog(@"Error:%@",error);

     }];


}
@end
