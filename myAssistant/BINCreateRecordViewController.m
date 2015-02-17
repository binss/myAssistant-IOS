//
//  BINCreateRecordViewController.m
//  myAssistant
//
//  Created by bin on 14/11/19.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINCreateRecordViewController.h"
#import "BINDatabaseManager.h"
#import <sqlite3.h>
@interface BINCreateRecordViewController ()

@end

@implementation BINCreateRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTextView.layer.borderColor = UIColor.blackColor.CGColor;
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.cornerRadius = 5.0;
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    self.yearTextField.text = [NSString stringWithFormat:@"%i",[dateComponent year]];
    self.monthTextField.text = [NSString stringWithFormat:@"%i",[dateComponent month]];
    self.dayTextField.text = [NSString stringWithFormat:@"%i",[dateComponent day]];
    self.timePicker.date = date;
    self.contentTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        // Code
    }];

}



- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender
{
    if([self.contentTextView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入日程内容！"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *timeString = [dateFormatter stringFromDate:[self.timePicker date]];
        [[BINDatabaseManager databaseManager] createRecord:self.yearTextField.text withMonth:self.monthTextField.text withDay:self.dayTextField.text withTime:timeString withContent:self.contentTextView.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        // Code
    }];


}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-200,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}


- (IBAction)backgroundTap:(id)sender {
    [self.contentTextView resignFirstResponder];
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为0，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
@end
