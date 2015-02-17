//
//  FirstViewController.m
//  myAssistant
//
//  Created by bin on 14/11/18.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "FirstViewController.h"
#import "BINDatabaseManager.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize dayContentArray;
@synthesize recentRecord;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    dayContentArray = [NSMutableArray arrayWithArray:[[BINDatabaseManager databaseManager] getDailyRecord]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDate *date = [NSDate date];
    [[BINDatabaseManager databaseManager] setCurrentDate:date];
    

    NSString *todayString = @"";
    
    NSMutableArray *dict = [[BINDatabaseManager databaseManager] getDailyRecord];
    NSLog(@"%@",dict);
    if ([dict count])
    {
        for (NSDictionary *dict in [[BINDatabaseManager databaseManager] getDailyRecord])
        {
    //        NSLog(@"%@",[dict objectForKey:@"content"]);

            todayString = [todayString stringByAppendingFormat:@"%@    %@\n\n",[dict objectForKey:@"time"], [dict objectForKey:@"content"]];
        }
        self.todayRecordTextView.text = todayString;
        self.todayRecordTextView.hidden = NO;
        self.nullImageView.hidden = YES;
    }
    else
    {
        self.todayRecordTextView.hidden = YES;
        self.nullImageView.hidden = NO;
    }
    
    recentRecord = [[BINDatabaseManager databaseManager] getRecentRecord];
    if(recentRecord)
    {
 
        self.recentReminderLabel.text = [NSString stringWithFormat:@"最近日程：%@",recentRecord[0]];
        self.recentReminderButton.hidden = NO;
    }
    else
    {
        self.recentReminderLabel.text = @"";
        self.recentReminderButton.hidden = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createButtonClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"createRecord" sender:self];
}
- (IBAction)synchrony:(UIButton *)sender
{
    [[BINDatabaseManager databaseManager] synchrony];
}

- (IBAction)recentReminderButtonClicked:(UIButton *)sender
{
    if([self.recentReminderButton.titleLabel.text isEqualToString:@"请提醒我"])
    {
        if([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
            
        {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification != nil)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSDate *date = [dateFormatter dateFromString:recentRecord[0]];
            notification.fireDate = date;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;          //加入声音
            notification.alertBody = recentRecord[1];
            
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            [self.recentReminderButton setTitle:@"取消提醒" forState:UIControlStateNormal];
        }
        NSLog(@"设置提醒成功");
    }
    else
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self.recentReminderButton setTitle:@"请提醒我" forState:UIControlStateNormal];
    }

}
@end
