//
//  BINCalendar.m
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINCalendar.h"

@implementation BINCalendar
@synthesize delegate;
@synthesize usefulButtons;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate
{
	if ((self = [super initWithFrame:frame]))
    {
		self.delegate = theDelegate;
		
		//用框架的大小来初始化日历的大小
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 9.0f;
		
		//设置背景
//		UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@""]];
		self.backgroundColor = [UIColor whiteColor];
		
		//添加日历顶部的两个按钮（上一月，下一月）并设置按钮触发调用函数
		UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
		prevBtn.frame = CGRectMake(0, 30, cellWidth, cellHeight);
		[prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
		nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 30, cellWidth, cellHeight);
		[nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		
        //添加显示当前月份的Label
		CGRect monthLabelFrame = CGRectMake(cellWidth, 30, calendarWidth - 2*cellWidth, cellHeight);
		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		monthLabel.font = [UIFont fontWithName:calendarFontName size:18];
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = [UIColor blackColor];
        
//        //添加显示当前月份的收入和支出Label
//        CGRect incomeLabelFrame = CGRectMake(0, 360, 150, 100);
//		incomeLabel = [[UILabel alloc] initWithFrame:incomeLabelFrame];
//		incomeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:18];
//		incomeLabel.textAlignment = NSTextAlignmentCenter;
//		incomeLabel.textColor = [UIColor blueColor];
//        
//        CGRect expenseLabelFrame = CGRectMake(170, 360, 150, 100);
//		expenseLabel = [[UILabel alloc] initWithFrame:expenseLabelFrame];
//		expenseLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:18];
//		expenseLabel.textAlignment = NSTextAlignmentCenter;
//		expenseLabel.textColor = [UIColor redColor];

		
        //把部件加载到view中
		[self addSubview: prevBtn];
		[self addSubview: nextBtn];
		[self addSubview: monthLabel];
//        [self addSubview: incomeLabel];
//        [self addSubview: expenseLabel];

        
        
		
		//添加星期并加载到view中
		char *days[7] = {"Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
		for(int i = 0; i < 7; i++)
        {
            //间隔为一个cell的宽度
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight + 20, cellWidth, cellHeight);
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
			dayLabel.font = [UIFont fontWithName:calendarFontName size:16];
			dayLabel.textColor = [UIColor darkGrayColor];
			
			[self addSubview:dayLabel];
		}
		
		[self drawDayButtons];
        //初始化usefulButtons数组
        usefulButtons = [[NSMutableArray alloc] initWithCapacity:31];
		
		//设置日历显示当前的月份
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		
		NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
		
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
		
    }
    return self;
}

- (void)drawDayButtons          //绘制每天的按钮
{
	dayButtons = [[NSMutableArray alloc] initWithCapacity:42];
    //绘制6行7列共42个按钮
	for (int i = 0; i < 6; i++)
    {
		for(int j = 0; j < 7; j++)
        {
			CGRect buttonFrame = CGRectMake(j*cellWidth , (i+2)*cellHeight + 10, cellWidth, cellHeight);
			BINDayButton *dayButton = [[BINDayButton alloc] initButtonWithFrame:buttonFrame];
			dayButton.titleLabel.font = [UIFont fontWithName:calendarFontName size:14];
			dayButton.delegate = self;
			
			[dayButtons addObject:dayButton];
			
			[self addSubview:[dayButtons lastObject]];
		}
	}
}

- (void)updateCalendarForMonth:(int)month forYear:(int)year         //设置当前月份的日历
{
    //设置当前年月
	char *months[12] = {"January", "Febrary", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"};
	monthLabel.text = [NSString stringWithFormat:@"%s %d", months[month - 1], year];
	
	//获取当前月份的第一天
	NSDateComponents *dateParts = [[NSDateComponents alloc] init];
	[dateParts setMonth:month];
	[dateParts setYear:year];
	[dateParts setDay:1];
	NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];

    //获取第一天是星期几
	NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:dateOnFirst];
	int weekdayOfFirst = [weekdayComponents weekday];
	
	int numDaysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay
										inUnit:NSCalendarUnitMonth
                                       forDate:dateOnFirst].length;
	
    
    [usefulButtons removeAllObjects];
	int day = 1;
	for (int i = 0; i < 6; i++)
    {
		for(int j = 0; j < 7; j++)
        {
			int buttonNumber = i * 7 + j;
			
			BINDayButton *button = [dayButtons objectAtIndex:buttonNumber];
			
            //默认设置按钮为无效（避免误按）
			button.enabled = NO;
			[button setTitle:nil forState:UIControlStateNormal];
			[button setButtonDate:nil];
            [button setBackgroundColor:[UIColor clearColor]];
			
            //如果当前按钮对应的数字大于等于第一天且总天数小于当前月份的天数，则设置该按钮的文字并设置它有效
			if(buttonNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth)
            {
				[button setTitle:[NSString stringWithFormat:@"%d", day]
                        forState:UIControlStateNormal];
				
				NSDateComponents *dateParts = [[NSDateComponents alloc] init];
				[dateParts setMonth:month];
				[dateParts setYear:year];
				[dateParts setDay:day];
				NSDate *buttonDate = [calendar dateFromComponents:dateParts];

				[button setButtonDate:buttonDate];
                
                //加入到usefulButtons数组中
                [usefulButtons addObject:button];
				
				++day;
                
                
			}
		}
	}
}

- (void)prevBtnPressed:(id)sender
{
    //如果当前为1月份，跳到上一年的12月份
	if(currentMonth == 1)
    {
		currentMonth = 12;
		--currentYear;
	} else
    {
		--currentMonth;
	}
	
    //更新日历
	[self updateCalendarForMonth:currentMonth forYear:currentYear];
	
	if ([self.delegate respondsToSelector:@selector(prevButtonPressed)])
    {
		[self.delegate prevButtonPressed];
	}
}

- (void)nextBtnPressed:(id)sender
{
    //如果当前为12月份，跳到下一年的1月份
	if(currentMonth == 12)
    {
		currentMonth = 1;
		++currentYear;
	} else
    {
		++currentMonth;
	}
	
	[self updateCalendarForMonth:currentMonth forYear:currentYear];
	
	if ([self.delegate respondsToSelector:@selector(nextButtonPressed)])
    {
		[self.delegate nextButtonPressed];
	}
}

- (void)dayButtonPressed:(id)sender
{
	BINDayButton *dayButton = (BINDayButton *) sender;
	[self.delegate dayButtonPressed:dayButton];
}

- (int)getCurrentMonth
{
    return currentMonth;
}

- (int)getCurrentYear
{
    return currentYear;
}

- (void)setButtonColor:(UIColor *) color dayIndex:(int)day
{
    BINDayButton *button = [usefulButtons objectAtIndex:day-1];
    button.backgroundColor = color;
}

- (void)setbuttonEnable:(BOOL) enable dayIndex:(int) day
{
    BINDayButton *button = [usefulButtons objectAtIndex:day-1];
    button.enabled = enable;
}

- (void)cleanButtonMode
{
    for (BINDayButton *button in usefulButtons) {
        button.backgroundColor = [UIColor whiteColor];
        button.enabled = NO;
    }
}

- (void)setIncomeAndExpense:(float) income withExpense:(float) expense
{
//    incomeLabel.text = [NSString stringWithFormat:@"收入：%.2f",income];
//    expenseLabel.text = [NSString stringWithFormat:@"支出：%.2f",expense];
}

@end
