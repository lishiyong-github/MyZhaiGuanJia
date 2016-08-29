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
        [self.contentView addSubview:self.getCodebutton];
        [self.contentView addSubview:self.loginSwitch];
        
        self.topConstraint = [self.loginTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.loginTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.loginTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.loginTextField autoSetDimension:ALDimensionWidth toSize:150];
        
        [self.getCodebutton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.getCodebutton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.loginTextField];
        [self.getCodebutton autoSetDimension:ALDimensionWidth toSize:80];
        
        [self.loginSwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.loginSwitch autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.loginTextField];
//        [self.loginSwitch autoSetDimension:ALDimensionHeight toSize:20];
//        [self.loginSwitch autoSetDimensionsToSize:CGSizeMake(100, 20)];
        
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

- (JKCountDownButton *)getCodebutton
{
    if (!_getCodebutton) {
        _getCodebutton = [JKCountDownButton newAutoLayoutView];
        _getCodebutton.titleLabel.font = kSecondFont;
    }
    return _getCodebutton;
}

- (UISwitch *)loginSwitch
{
    if (!_loginSwitch) {//79*27
        _loginSwitch = [UISwitch newAutoLayoutView];
        _loginSwitch.onTintColor = kBlueColor;
        _loginSwitch.tintColor = kSeparateColor;
        [_loginSwitch addTarget:self action:@selector(tagSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _loginSwitch;
}

- (void)tagSwitch:(UISwitch *)sender
{
    if (self.didEndSwitching) {
        self.didEndSwitching(sender.isOn);
    }
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
