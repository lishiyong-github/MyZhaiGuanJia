//
//  MainProductview.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MainProductview.h"

@implementation MainProductview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.userImageView];
        [self addSubview:self.storeButton];
        [self addSubview:self.categoryLabel1];
        [self addSubview:self.categoryLabel2];
        [self addSubview:self.categoryLabel3];
        [self addSubview:self.categoryLabel4];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.applyButton];
        [self addSubview:self.line11];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.userImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.userImageView autoSetDimensionsToSize:CGSizeMake(36, 36)];
        [self.userImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.storeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2];
        [self.storeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageView];
        
        [self.categoryLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.categoryLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageView withOffset:kBigPadding];
        
        [self.categoryLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.categoryLabel1 withOffset:kBigPadding];
        [self.categoryLabel2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.categoryLabel1];
        
        [self.categoryLabel3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.categoryLabel1];
        [self.categoryLabel3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.categoryLabel1 withOffset:kSpacePadding];
        
        [self.categoryLabel4 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.categoryLabel3];
        [self.categoryLabel4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.categoryLabel2];
        
        [self.leftButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.categoryLabel1 withOffset:kBigPadding*2];
        [self.leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.leftButton autoSetDimension:ALDimensionWidth toSize:self.width/2];
        
        [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.rightButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.leftButton];
        [self.rightButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.leftButton];
        
        [self.applyButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.leftButton withOffset:16];
        [self.applyButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.applyButton autoSetDimension:ALDimensionWidth toSize:72];
        [self.applyButton autoSetDimension:ALDimensionHeight toSize:24];
        
        [self.line11 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.line11 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.leftButton withOffset:kSpacePadding];
        [self.line11 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.leftButton withOffset:-kSpacePadding];
        [self.line11 autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [UIImageView newAutoLayoutView];
        _userImageView.layer.cornerRadius = 18;
        _userImageView.layer.masksToBounds = YES;
    }
    return _userImageView;
}

- (UIButton *)storeButton
{
    if (!_storeButton) {
        _storeButton = [UIButton newAutoLayoutView];
    }
    return _storeButton;
}

- (UILabel *)categoryLabel1
{
    if (!_categoryLabel1) {
        _categoryLabel1 = [UILabel newAutoLayoutView];
        _categoryLabel1.textColor = kBlackColor;
        _categoryLabel1.font = [UIFont systemFontOfSize:10];
        _categoryLabel1.layer.borderColor = kBorderColor.CGColor;
        _categoryLabel1.layer.borderWidth = kLineWidth;
    }
    return _categoryLabel1;
}

- (UILabel *)categoryLabel2
{
    if (!_categoryLabel2) {
        _categoryLabel2 = [UILabel newAutoLayoutView];
        _categoryLabel2.textColor = kBlackColor;
        _categoryLabel2.font = [UIFont systemFontOfSize:10];
        _categoryLabel2.layer.borderColor = kBorderColor.CGColor;
        _categoryLabel2.layer.borderWidth = kLineWidth;
    }
    return _categoryLabel2;
}

- (UILabel *)categoryLabel3
{
    if (!_categoryLabel3) {
        _categoryLabel3 = [UILabel newAutoLayoutView];
        _categoryLabel3.textColor = kBlackColor;
        _categoryLabel3.font = [UIFont systemFontOfSize:10];
        _categoryLabel3.layer.borderColor = kBorderColor.CGColor;
        _categoryLabel3.layer.borderWidth = kLineWidth;
    }
    return _categoryLabel3;
}

- (UILabel *)categoryLabel4
{
    if (!_categoryLabel4) {
        _categoryLabel4 = [UILabel newAutoLayoutView];
        _categoryLabel4.textColor = kBlackColor;
        _categoryLabel4.font = [UIFont systemFontOfSize:10];
        _categoryLabel4.layer.borderColor = kBorderColor.CGColor;
        _categoryLabel4.layer.borderWidth = kLineWidth;
    }
    return _categoryLabel4;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton newAutoLayoutView];
        _leftButton.titleLabel.numberOfLines = 0;
        _leftButton.userInteractionEnabled = NO;
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton newAutoLayoutView];
        _rightButton.titleLabel.numberOfLines = 0;
        _rightButton.userInteractionEnabled = NO;
    }
    return _rightButton;
}

- (UIButton *)applyButton
{
    if (!_applyButton) {
        _applyButton = [UIButton newAutoLayoutView];
        _applyButton.layer.borderWidth = kLineWidth;
        _applyButton.layer.cornerRadius = 12;
        _applyButton.titleLabel.font = kSecondFont;
    }
    return _applyButton;
}

- (UILabel *)line11
{
    if (!_line11) {
        _line11 = [UILabel newAutoLayoutView];
        _line11.backgroundColor = kSeparateColor;
    }
    return _line11;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
