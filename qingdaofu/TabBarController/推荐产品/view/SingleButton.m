//
//  SingleButton.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SingleButton.h"

@interface SingleButton ()

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation SingleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.button];
        [self addSubview:self.label];
        
        [self setNeedsUpdateConstraints];
        
       self.spaceConstraints =  [self.label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.button withOffset:kBigPadding];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self.button autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [self.button autoSetDimensionsToSize:CGSizeMake(80, 80)];
        [self.button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
       
        [self.label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.button withOffset:kBigPadding];
        [self.label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton newAutoLayoutView];
        _button.layer.masksToBounds = YES;
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel newAutoLayoutView];
        _label.font = kSecondFont;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = kGrayColor;
    }
    return _label;
}

@end
