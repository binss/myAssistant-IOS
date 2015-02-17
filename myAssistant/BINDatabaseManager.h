//
//  BINDatabaseManager.h
//  myAssistant
//
//  Created by bin on 14/11/20.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BINDatabaseManager : NSObject
{
    sqlite3 *db;

}

+ (BINDatabaseManager *)databaseManager;
- (NSMutableArray *)getMonthlyRecordIndex:(int)year withMonth:(int)month;
- (NSMutableArray *)getDailyRecord;
- (void)createRecord:(NSString*)year withMonth:(NSString*)month withDay:(NSString*)day withTime:(NSString*)time withContent:(NSString*)content;
- (void)modifyRecord:(NSString*)time withContent:(NSString*)content;
- (void)deleteRecord;
- (void)synchrony;
- (NSArray *)getRecentRecord;
- (NSString *)checkTime:(int)time;
@property (nonatomic,strong) NSDate * currentDate;
@property (nonatomic,strong) NSDictionary * currentRecord;

@end
