//
//  AuthenBaseView.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenBaseView.h"
#import "UIButton+Addition.h"

@interface AuthenBaseView ()<UITextFieldDelegate>

@property (nonatomic,assign) CGFloat lH;
@property (nonatomic,assign) CGFloat lW;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation AuthenBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.label];
        [self addSubview:self.textField];
        [self addSubview:self.button];
        
        self.leftTextConstraints = [self.textField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:105];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) {
    
        [self.label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.label autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.textField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.label];
        
        [self.button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel newAutoLayoutView];
        _label.font = kBigFont;
        _label.text = @"联系方式";
        _label.textColor = kBlackColor;
        _label.numberOfLines = 0;
    }
    return _label;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField newAutoLayoutView];
        _textField.font = kFirstFont;
        _textField.textColor = kBlackColor;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton newAutoLayoutView];
        _button.titleLabel.font = kSecondFont;
        [_button setTitleColor:kLightGrayColor forState:0];
        [_button swapImage];
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
