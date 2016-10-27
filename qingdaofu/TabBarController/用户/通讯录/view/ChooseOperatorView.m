//
//  ChooseOperatorView.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ChooseOperatorView.h"

@implementation ChooseOperatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.aButton];
        [self addSubview:self.bButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.aButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [self.aButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.bButton];
        
        [self.bButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        [self.bButton autoSetDimension:ALDimensionWidth toSize:100];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)aButton
{
    if (!_aButton) {
        _aButton = [UIButton newAutoLayoutView];
        [_aButton setBackgroundColor:kWhiteColor];
        [_aButton setTitleColor:kBlackColor forState:0];
        _aButton.titleLabel.font = kFourFont;
        [_aButton setContentEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        [_aButton setContentHorizontalAlignment:1];
    }
    return _aButton;
}

- (UIButton *)bButton
{
    if (!_bButton) {
        _bButton = [UIButton newAutoLayoutView];
        [_bButton setTitleColor:kWhiteColor forState:0];
        _bButton.titleLabel.font = kFourFont;
        _bButton.backgroundColor = kButtonColor;
        [_bButton setTitle:@"添加到经办人" forState:0];
    }
    return _bButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
