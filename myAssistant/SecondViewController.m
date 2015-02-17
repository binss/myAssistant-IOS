//
//  SecondViewController.m
//  myAssistant
//
//  Created by bin on 14/11/18.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "SecondViewController.h"
#import "BINDayViewController.h"
#import "BINDatabaseManager.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize dictionary;
@synthesize filePath;

- (void)loadView
{
    UIView *appView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    calendarView = [[BINCalendar alloc] initWithFrame:appView.bounds fontName:@"AmericanTypewriter" delegate:self];
    
    self.view = appView;
    
    [self.view addSubview: calendarView];
    
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
//    
//    [self.navigationItem setHidesBackButton:YES];
    
    // 增加左右滑动手势识别
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dayButtonPressed:(BINDayButton *)button
{
    currentSelectedDate = button.buttonDate;


    [[BINDatabaseManager databaseManager] setCurrentDate:currentSelectedDate];
    [self performSegueWithIdentifier:@"goDayView" sender:self];


}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    UIViewController *targetController = destination.childViewControllers[0];
    [targetController setValue:currentSelectedDate forKey:@"date"];

}

- (void)nextButtonPressed
{
    NSLog(@"%d,%d",calendarView.getCurrentYear,calendarView.getCurrentMonth);
    [self loadFile];
}

- (void)prevButtonPressed
{
    NSLog(@"%d,%d",calendarView.getCurrentYear,calendarView.getCurrentMonth);
    [self loadFile];
    
}


- (void)loadFile
{
    [calendarView cleanButtonMode];
    
    NSMutableArray *activeDayList = [[BINDatabaseManager databaseManager] getMonthlyRecordIndex:[calendarView getCurrentYear] withMonth:[calendarView getCurrentMonth]];
//    NSLog(@"%@",activeDayList);
    for (NSNumber *day in activeDayList)
    {
        [calendarView setButtonColor:[UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1] dayIndex:[day intValue]];
        [calendarView setbuttonEnable:YES dayIndex:[day intValue]];

    }

}

-(void)handleSwipeFromRight:(id)sender
{
    [calendarView prevBtnPressed:sender];
}

-(void)handleSwipeFromLeft:(id)sender
{
    [calendarView nextBtnPressed:sender];
}

@end
