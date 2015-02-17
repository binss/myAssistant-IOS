//
//  BINDayButton.h
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol DayButtonDelegate <NSObject>
@required
- (void)dayButtonPressed:(id)sender;

@end


@interface BINDayButton : UIButton
{
    __unsafe_unretained id <DayButtonDelegate> delegate;
	NSDate *buttonDate;
}

@property (assign,nonatomic) id <DayButtonDelegate> delegate;      //weak?
@property (nonatomic, copy) NSDate *buttonDate;

- (id)initButtonWithFrame:(CGRect)buttonFrame;


@end


