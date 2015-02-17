//
//  BINModifyRecordViewController.h
//  myAssistant
//
//  Created by bin on 14/11/19.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINModifyRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
- (IBAction)saveButtonClicked:(id)sender;
@property (strong,nonatomic) NSDictionary *currentRecord;
- (IBAction)backgroundTap:(UIControl *)sender;

@end
