//
//  BaseRemindButton.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseRemindButton.h"

@implementation BaseRemindButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kYellowColor;
        self.titleLabel.font = kFourFont;
        [self setTitleColor:kNavColor forState:0];
        [self swapImage];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
