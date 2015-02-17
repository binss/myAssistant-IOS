//
//  BINCreateRecordViewController.h
//  myAssistant
//
//  Created by bin on 14/11/19.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINCreateRecordViewController : UIViewController
- (IBAction)backButtonClicked:(UIBarButtonItem *)sender;
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
- (IBAction)backgroundTap:(id)sender;

@end
