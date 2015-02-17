//
//  SecondViewController.h
//  myAssistant
//
//  Created by bin on 14/11/18.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BINCalendar.h"
#import <sqlite3.h>

@interface SecondViewController : UIViewController<BINCalendarDelegate>
{
    BINCalendar *calendarView;
    sqlite3 *db;
    NSDate *currentSelectedDate;

}
@property  (strong,nonatomic) NSMutableDictionary *dictionary;
@property  (strong,nonatomic) NSString *filePath;

@end

