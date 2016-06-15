//
//  AllProSegView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AllProSegView.h"

@implementation AllProSegView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.allButton];
        [self addSubview:self.ingButton];
        [self addSubview:self.dealButton];
        [self addSubview:self.endButton];
        [self addSubview:self.closeButton];
        [self addSubview:self.tBlueLabel];
        [self addSubview:self.tGrayLabel];
        
        self.leftsConstraints = [self.tBlueLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.allButton withOffset:0];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.allButton,self.ingButton,self.dealButton,self.endButton,self.closeButton];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/5, 40)];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.allButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.allButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        
        [self.ingButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.allButton];
        
        [self.dealButton autoCenterInSuperview];
        
        [self.endButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dealButton];
        
        [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.tBlueLabel autoSetDimension:ALDimensionWidth toSize:kScreenWidth/5];
        [self.tBlueLabel autoSetDimension:ALDimensionHeight toSize:2];
        [self.tBlueLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2];
        
        [self.tGrayLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.tGrayLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.tGrayLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.tGrayLabel autoSetDimension:ALDimensionHeight toSize:0.5];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)allButton
{
    if (!_allButton) {
        _allButton = [UIButton newAutoLayoutView];
        _allButton.titleLabel.font = kBigFont;
        [_allButton setTitleColor:kBlackColor forState:0];
        [_allButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        QDFWeakSelf;
        [_allButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            
            [UIView animateWithDuration:5 animations:^{
                weakself.leftsConstraints.constant = 0;
            }];
            
            [weakself.ingButton setTitleColor:kBlackColor forState:0];
            [weakself.dealButton setTitleColor:kBlackColor forState:0];
            [weakself.endButton setTitleColor:kBlackColor forState:0];
            [weakself.closeButton setTitleColor:kBlackColor forState:0];
            
            if (weakself.didSelectedSeg) {
                weakself.didSelectedSeg(111);
            }
        }];
    }
    return _allButton;
}

- (UIButton *)ingButton
{
    if (!_ingButton) {
        _ingButton = [UIButton newAutoLayoutView];
        _ingButton.titleLabel.font = kBigFont;
        [_ingButton setTitleColor:kBlackColor forState:0];
        [_ingButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        QDFWeakSelf;
        [_ingButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            
            [UIView animateWithDuration:2 animations:^{
                weakself.leftsConstraints.constant = kScreenWidth/5;
            }];
            
            [weakself.allButton setTitleColor:kBlackColor forState:0];
            [weakself.dealButton setTitleColor:kBlackColor forState:0];
            [weakself.endButton setTitleColor:kBlackColor forState:0];
            [weakself.closeButton setTitleColor:kBlackColor forState:0];
            if (weakself.didSelectedSeg) {
                weakself.didSelectedSeg(112);
            }
        }];
    }
    return _ingButton;
}

- (UIButton *)dealButton
{
    if (!_dealButton) {
        _dealButton = [UIButton newAutoLayoutView];
        _dealButton.titleLabel.font = kBigFont;
        [_dealButton setTitleColor:kBlackColor forState:0];
        [_dealButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_dealButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            
            [UIView animateWithDuration:2 animations:^{
                weakself.leftsConstraints.constant = kScreenWidth/5*2;
            }];
            
            [weakself.allButton setTitleColor:kBlackColor forState:0];
            [weakself.ingButton setTitleColor:kBlackColor forState:0];
            [weakself.endButton setTitleColor:kBlackColor forState:0];
            [weakself.closeButton setTitleColor:kBlackColor forState:0];
            if (weakself.didSelectedSeg) {
                weakself.didSelectedSeg(113);
            }
        }];
    }
    return _dealButton;
}

- (UIButton *)endButton
{
    if (!_endButton) {
        _endButton = [UIButton newAutoLayoutView];
        _endButton.titleLabel.font = kBigFont;
        [_endButton setTitleColor:kBlackColor forState:0];
        [_endButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_endButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            
            [UIView animateWithDuration:2 animations:^{
                weakself.leftsConstraints.constant = kScreenWidth/5*3;
            }];
            
            [weakself.allButton setTitleColor:kBlackColor forState:0];
            [weakself.ingButton setTitleColor:kBlackColor forState:0];
            [weakself.dealButton setTitleColor:kBlackColor forState:0];
            [weakself.closeButton setTitleColor:kBlackColor forState:0];
            if (weakself.didSelectedSeg) {
                weakself.didSelectedSeg(114);
            }
        }];

    }
    return _endButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton newAutoLayoutView];
        _closeButton.titleLabel.font = kBigFont;
        [_closeButton setTitleColor:kBlackColor forState:0];
        [_closeButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        
        QDFWeakSelf;
        [_closeButton addAction:^(UIButton *btn) {
            [btn setTitleColor:kBlueColor forState:0];
            
            [UIView animateWithDuration:2 animations:^{
                weakself.leftsConstraints.constant = kScreenWidth/5*4;
            }];
            
            [weakself.allButton setTitleColor:kBlackColor forState:0];
            [weakself.ingButton setTitleColor:kBlackColor forState:0];
            [weakself.dealButton setTitleColor:kBlackColor forState:0];
            [weakself.endButton setTitleColor:kBlackColor forState:0];
            if (weakself.didSelectedSeg) {
                weakself.didSelectedSeg(115);
            }
        }];

    }
    return _closeButton;
}

- (UILabel *)tBlueLabel
{
    if (!_tBlueLabel) {
        _tBlueLabel = [UILabel newAutoLayoutView];
        _tBlueLabel.backgroundColor = kBlueColor;
    }
    return _tBlueLabel;
}

- (UILabel *)tGrayLabel
{
    if (!_tGrayLabel) {
        _tGrayLabel = [UILabel newAutoLayoutView];
        _tGrayLabel.backgroundColor = kLightGrayColor;
    }
    return _tGrayLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
