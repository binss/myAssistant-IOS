//
//  FirstViewController.h
//  myAssistant
//
//  Created by bin on 14/11/18.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

- (IBAction)createButtonClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextView *todayRecordTextView;
@property (strong, nonatomic) NSMutableArray * dayContentArray;
- (IBAction)synchrony:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *recentReminderLabel;
@property (strong, nonatomic) NSArray *recentRecord;
- (IBAction)recentReminderButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *nullImageView;
@property (weak, nonatomic) IBOutlet UIButton *recentReminderButton;


@end

