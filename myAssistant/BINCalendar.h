//
//  BINCalendar.h
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BINDayButton.h"

@protocol BINCalendarDelegate <NSObject>
- (void)dayButtonPressed:(BINDayButton *)button;

@optional
- (void)prevButtonPressed;
- (void)nextButtonPressed;

@end


@interface BINCalendar : UIView <DayButtonDelegate>
{
	__unsafe_unretained id <BINCalendarDelegate> delegate;
	NSString *calendarFontName;
	UILabel *monthLabel;
    UILabel *incomeLabel;
    UILabel *expenseLabel;
	NSMutableArray *dayButtons;
	NSCalendar *calendar;
	float calendarWidth;
	float calendarHeight;
	float cellWidth;
	float cellHeight;
	int currentMonth;
	int currentYear;
}

@property(nonatomic, assign) id <BINCalendarDelegate> delegate;
@property (strong,nonatomic) NSMutableArray * usefulButtons;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate;
- (void)updateCalendarForMonth:(int)month forYear:(int)year;
- (void)drawDayButtons;
- (void)prevBtnPressed:(id)sender;
- (void)nextBtnPressed:(id)sender;
- (int)getCurrentMonth;
- (int)getCurrentYear;
- (void)setbuttonEnable:(BOOL) enable dayIndex:(int) day;
- (void)setButtonColor:(UIColor *) color dayIndex:(int)day;
- (void)setIncomeAndExpense:(float) income withExpense:(float) expense;
- (void)cleanButtonMode;
@end
