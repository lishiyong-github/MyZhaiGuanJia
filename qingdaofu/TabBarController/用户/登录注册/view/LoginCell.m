//
//  LoginCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.loginTextField];
        [self.contentView addSubview:self.loginButton];
        [self.contentView addSubview:self.getCodebutton];
        
        self.topConstraint = [self.loginTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.loginTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.loginTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.loginTextField autoSetDimension:ALDimensionWidth toSize:150];
        
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.loginButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.loginTextField];
        
        [self.getCodebutton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.getCodebutton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.loginTextField];
        [self.getCodebutton autoSetDimension:ALDimensionWidth toSize:80];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITextField *)loginTextField
{
    if (!_loginTextField) {
        _loginTextField = [UITextField newAutoLayoutView];
        _loginTextField.textColor = kBlackColor;
        _loginTextField.font = kBigFont;
        _loginTextField.delegate = self;
    }
    return _loginTextField;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton newAutoLayoutView];
        _loginButton.titleLabel.font = kSecondFont;
        [_loginButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_loginButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
            if (btn.selected) {
                weakself.loginTextField.secureTextEntry = NO;
            }else{
                weakself.loginTextField.secureTextEntry = YES;
            }
        }];
    }
    return _loginButton;
}

- (JKCountDownButton *)getCodebutton
{
    if (!_getCodebutton) {
        _getCodebutton = [JKCountDownButton newAutoLayoutView];
        _getCodebutton.titleLabel.font = kSecondFont;
    }
    return _getCodebutton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.finishEditing) {
        self.finishEditing(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
