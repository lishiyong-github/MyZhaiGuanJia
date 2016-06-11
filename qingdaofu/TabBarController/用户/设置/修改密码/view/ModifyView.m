//
//  ModifyView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ModifyView.h"

@implementation ModifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftTextField];
        [self addSubview:self.rightButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = @[self.leftTextField,self.rightButton];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.leftTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
        [self.leftTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITextField *)leftTextField
{
    if (!_leftTextField) {
        _leftTextField =[UITextField newAutoLayoutView];
        _leftTextField.textColor = kLightGrayColor;
        _leftTextField.font = kBigFont;
        _leftTextField.secureTextEntry = YES;
    }
    return _leftTextField;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton newAutoLayoutView];
        _rightButton.titleLabel.font = kSecondFont;
        [_rightButton setTitleColor:kBlueColor forState:0];
    }
    return _rightButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
