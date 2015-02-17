//
//  BINModifyRecordViewController.m
//  myAssistant
//
//  Created by bin on 14/11/19.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINModifyRecordViewController.h"
#import "BINDatabaseManager.h"

@interface BINModifyRecordViewController ()

@end

@implementation BINModifyRecordViewController
@synthesize currentRecord;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextView.layer.borderColor = UIColor.blackColor.CGColor;
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.cornerRadius = 5.0;
    
    currentRecord = [NSDictionary dictionaryWithDictionary:[[BINDatabaseManager databaseManager] currentRecord]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSDate *time= [dateFormatter dateFromString:[currentRecord objectForKey:@"time"]];
    
    [self.timePicker setDate:time];
    [self.contentTextView setText:[currentRecord objectForKey:@"content"]];
    
    self.contentTextView.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)saveButtonClicked:(id)sender
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
        [[BINDatabaseManager databaseManager] modifyRecord:timeString withContent:self.contentTextView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)backgroundTap:(UIControl *)sender
{
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
