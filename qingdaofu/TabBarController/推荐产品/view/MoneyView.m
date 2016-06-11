//
//  MoneyView.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MoneyView.h"

@interface MoneyView ()

@property (nonatomic,assign) CGFloat lH1;
@property (nonatomic,assign) CGFloat lH2;

@end

@implementation MoneyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.label1];
        [self addSubview:self.label2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.label1,self.label2];
        [views autoAlignViewsToAxis:ALAxisVertical];
        
        [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.label1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.label2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label1 withOffset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [UILabel newAutoLayoutView];
        _label1.font = [UIFont systemFontOfSize:24];
        _label1.textAlignment = NSTextAlignmentCenter;
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2) {
        _label2 = [UILabel newAutoLayoutView];
        _label2.textColor = kLightGrayColor;
        _label2.font = kSecondFont;
    }
    return _label2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
