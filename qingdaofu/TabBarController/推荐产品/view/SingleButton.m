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
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.button autoSetDimensionsToSize:CGSizeMake(55, 55)];
        
        [self.label autoAlignAxis:ALAxisVertical toSameAxisOfView:self.button];
        [self.label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.button withOffset:5];
        
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
        _label.font = kBigFont;
//        _label.text = @"发布清收";
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
