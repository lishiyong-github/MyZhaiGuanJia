//
//  CallPhoneButton.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CallPhoneButton.h"

@implementation CallPhoneButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"customer_service_hotline"] forState:0];
        
        [self addAction:^(UIButton *btn) {
            NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://400-855-7022"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }];
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
