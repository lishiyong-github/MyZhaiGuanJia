//
//  DialogBoxView.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DialogBoxView.h"

@implementation DialogBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dialogTextField];
        [self addSubview:self.dialogButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.dialogTextField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(4, 8, 4, 0) excludingEdge:ALEdgeRight];
        [self.dialogTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.dialogButton withOffset:-kBigPadding];
        
        [self.dialogButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 0, 4, 8) excludingEdge:ALEdgeLeft];
        [self.dialogButton autoSetDimension:ALDimensionWidth toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITextField *)dialogTextField
{
    if (!_dialogTextField) {
        _dialogTextField = [UITextField newAutoLayoutView];
        _dialogTextField.placeholder = @"请输入留言";
        _dialogTextField.font = kSecondFont;
        _dialogTextField.textColor = kBlackColor;
        _dialogTextField.backgroundColor = kBackColor;
        _dialogTextField.delegate = self;
        _dialogTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSpacePadding, 0)];
        _dialogTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _dialogTextField;
}

- (UIButton *)dialogButton
{
    if (!_dialogButton) {
        _dialogButton = [UIButton newAutoLayoutView];
        [_dialogButton setTitle:@"发送" forState:0];
        [_dialogButton setTitleColor:kWhiteColor forState:0];
        [_dialogButton setBackgroundColor:kButtonColor];
        _dialogButton.titleLabel.font = kSecondFont;
    }
    return _dialogButton;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.didEndEditting) {
        self.didEndEditting(textField.text);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
