//
//  BaseCommitView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseCommitView.h"

@implementation BaseCommitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kNavColor;
        self.layer.borderWidth = kLineWidth;
        self.layer.borderColor = kBorderColor.CGColor;
        
        [self addSubview:self.button];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.button autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (BaseCommitButton *)button
{
    if (!_button) {
        _button = [BaseCommitButton newAutoLayoutView];
    }
    return _button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
