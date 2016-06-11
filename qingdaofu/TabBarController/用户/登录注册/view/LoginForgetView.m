//
//  LoginForgetView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LoginForgetView.h"

@implementation LoginForgetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.loginCommitButton];
        [self addSubview:self.forgrtButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.loginCommitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.loginCommitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.loginCommitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.loginCommitButton autoSetDimension:ALDimensionHeight toSize:40];

        
        [self.forgrtButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginCommitButton withOffset:kBigPadding];
        [self.forgrtButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.loginCommitButton];
       
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (BaseCommitButton *)loginCommitButton
{
    if (!_loginCommitButton) {
        _loginCommitButton = [BaseCommitButton newAutoLayoutView];
        [_loginCommitButton setTitle:@"登录" forState:0];
        QDFWeakSelf;
        [_loginCommitButton addAction:^(UIButton *btn) {
            if (weakself.didSelecBtn) {
                weakself.didSelecBtn(21);
            }
        }];
    }
    return _loginCommitButton;
}

- (UIButton *)forgrtButton
{
    if (!_forgrtButton) {
        _forgrtButton = [UIButton newAutoLayoutView];
        [_forgrtButton setTitleColor:kBlueColor forState:0];
        _forgrtButton.titleLabel.font = kSecondFont;
        [_forgrtButton setTitle:@"忘记密码?" forState:0];
        QDFWeakSelf;
        [_forgrtButton addAction:^(UIButton *btn) {
            if (weakself.didSelecBtn) {
                weakself.didSelecBtn(22);
            }
        }];
    }
    return _forgrtButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
