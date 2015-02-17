//
//  BINDayButton.m
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDayButton.h"

@implementation BINDayButton
@synthesize delegate,buttonDate;

- (id)initButtonWithFrame:(CGRect)buttonFrame
{
	self = [BINDayButton buttonWithType:UIButtonTypeCustom];
	self.frame = buttonFrame;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.backgroundColor = [UIColor clearColor];
	[self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	
	[self addTarget:delegate action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	UILabel *titleLabel = [self titleLabel];
	CGRect labelFrame = titleLabel.frame;
	int framePadding = 4;
	labelFrame.origin.x = self.bounds.size.width - labelFrame.size.width - framePadding;
	labelFrame.origin.y = framePadding;
	
	[self titleLabel].frame = labelFrame;
}



@end
