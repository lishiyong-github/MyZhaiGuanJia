//
//  AllNumberButton.m
//  qingdaofu
//
//  Created by zhixiang on 16/12/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AllNumberButton.h"

@implementation AllNumberButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.numberButton];
        [self addSubview:self.listMoreButton];
        
        [self setNeedsUpdateConstraints];
        
//        [self swapImage];
//        
//        [self setContentHorizontalAlignment:3];
//        [self setImage:[UIImage imageNamed:@"list_more"] forState:0];
//        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kBigPadding)];
//        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
//        self.titleLabel.numberOfLines = 0;
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
