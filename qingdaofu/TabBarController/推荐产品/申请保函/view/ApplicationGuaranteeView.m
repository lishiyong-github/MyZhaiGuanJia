//
//  ApplicationGuaranteeView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationGuaranteeView.h"

@implementation ApplicationGuaranteeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.firstButton];
        [self addSubview:self.secondButton];
        [self addSubview:self.thirdButton];
        [self addSubview:self.blueLabel];
        
        self.leftBlueConstraints = [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.firstButton,self.secondButton,self.thirdButton];
        [views autoMatchViewsDimension:ALDimensionWidth];
        
        [self.firstButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.firstButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.firstButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.secondButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.secondButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.secondButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.firstButton];
        [self.secondButton autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];
        
        [self.thirdButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.thirdButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.thirdButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.blueLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.blueLabel autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];
        [self.blueLabel autoSetDimension:ALDimensionHeight toSize:2];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)firstButton
{
    if (!_firstButton) {
        _firstButton = [UIButton newAutoLayoutView];
        [_firstButton setTitleColor:kTextColor forState:0];
        _firstButton.titleLabel.font = kFirstFont;
    }
    return _firstButton;
}

- (UIButton *)secondButton
{
    if (!_secondButton) {
        _secondButton = [UIButton newAutoLayoutView];
        [_secondButton setTitleColor:kGrayColor forState:0];
        _secondButton.titleLabel.font = kFirstFont;
    }
    return _secondButton;
}

- (UIButton *)thirdButton
{
    if (!_thirdButton) {
        _thirdButton = [UIButton newAutoLayoutView];
        [_thirdButton setTitleColor:kGrayColor forState:0];
        _thirdButton.titleLabel.font = kFirstFont;
    }
    return _thirdButton;
}

- (UILabel *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = [UILabel newAutoLayoutView];
        _blueLabel.backgroundColor = kButtonColor;
    }
    return _blueLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
