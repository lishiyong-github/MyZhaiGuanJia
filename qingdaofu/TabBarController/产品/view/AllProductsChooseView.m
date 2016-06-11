//
//  AllProductsChooseView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AllProductsChooseView.h"

@implementation AllProductsChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.squrebutton];
        [self addSubview:self.stateButton];
        [self addSubview:self.moneyButton];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.squrebutton,self.stateButton,self.moneyButton];
        [views autoMatchViewsDimension:ALDimensionWidth];
        
        
        [self.squrebutton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.squrebutton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.squrebutton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.stateButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.stateButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.stateButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.squrebutton];
        [self.stateButton autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];
        
        
        [self.moneyButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.moneyButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.moneyButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)squrebutton
{
    if (!_squrebutton) {
        _squrebutton = [UIButton newAutoLayoutView];
        [_squrebutton setTitleColor:kGrayColor forState:0];
        _squrebutton.layer.borderColor = kSeparateColor.CGColor;
        _squrebutton.layer.borderWidth = kLineWidth;
        _squrebutton.titleLabel.font = kBigFont;
        [_squrebutton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
        [_squrebutton setImageEdgeInsets:UIEdgeInsetsMake(27.5, kScreenWidth/3-12.5, 5, 5)];
        _squrebutton.tag = 201;
        
        
        QDFWeakSelf;
        [_squrebutton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            [btn setImage:[UIImage imageNamed:@"select_oepn_s"] forState:0];

            [weakself.stateButton setTitleColor:kGrayColor forState:0];
            [weakself.stateButton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
            
            [weakself.moneyButton setTitleColor:kGrayColor forState:0];
            [weakself.moneyButton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
            
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
            
        }];
    }
    return _squrebutton;
}

- (UIButton *)stateButton
{
    if (!_stateButton) {
        _stateButton = [UIButton newAutoLayoutView];
        [_stateButton setTitleColor:kGrayColor forState:0];
        _stateButton.layer.borderColor = kSeparateColor.CGColor;
        _stateButton.layer.borderWidth = kLineWidth;
        _stateButton.titleLabel.font = kBigFont;
        [_stateButton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
        [_stateButton setImageEdgeInsets:UIEdgeInsetsMake(27.5, kScreenWidth/3-12.5, 5, 5)];
        _stateButton.tag = 202;
        
        QDFWeakSelf;
        [_stateButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            [btn setImage:[UIImage imageNamed:@"select_oepn_s"] forState:0];
            
            [weakself.squrebutton setTitleColor:kGrayColor forState:0];
            [weakself.squrebutton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
            
            [weakself.moneyButton setTitleColor:kGrayColor forState:0];
            [weakself.moneyButton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
            
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
        }];
    }
    return _stateButton;
}

- (UIButton *)moneyButton
{
    if (!_moneyButton) {
        _moneyButton = [UIButton newAutoLayoutView];
        [_moneyButton setTitleColor:kGrayColor forState:0];
        _moneyButton.layer.borderColor = kSeparateColor.CGColor;
        _moneyButton.layer.borderWidth = kLineWidth;
        _moneyButton.titleLabel.font = kBigFont;
        [_moneyButton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
        [_moneyButton setImageEdgeInsets:UIEdgeInsetsMake(27.5, kScreenWidth/3-12.5, 5, 5)];
        _moneyButton.tag = 203;

        QDFWeakSelf;
        [_moneyButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            [btn setImage:[UIImage imageNamed:@"select_oepn_s"] forState:0];
            
            [weakself.squrebutton setTitleColor:kGrayColor forState:0];
            [weakself.squrebutton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
            
            [weakself.stateButton setTitleColor:kGrayColor forState:0];
            [weakself.stateButton setImage:[UIImage imageNamed:@"select_oepn"] forState:0];
            
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
        }];
    }
    return _moneyButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
