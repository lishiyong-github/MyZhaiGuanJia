//
//  BaseLabel.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseLabel.h"
#import "UIButton+Addition.h"

@interface BaseLabel ()

@property (nonatomic,assign) CGFloat lH;

@end

@implementation BaseLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.tagImageView];
        [self addSubview:self.goButton];
        
        [self setNeedsUpdateConstraints];
        
        _aH = 30+_lH;
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = @[self.nameLabel,self.tagImageView,self.goButton];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.tagImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:5];
        [self.tagImageView autoSetDimensionsToSize:CGSizeMake(24, 24)];
        
        [self.goButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
//        [self.goButton autoSetDimensionsToSize:CGSizeMake(15, 15)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.textColor = kBlackColor;
//        _nameLabel.text = @"借款人年龄";
        _nameLabel.font = kBigFont;
        _nameLabel.numberOfLines = 0;
        CGSize size = [_nameLabel.text sizeWithAttributes:@{NSFontAttributeName:kBigFont}];
        _lH = size.height;
    }
    return _nameLabel;
}

- (UIImageView *)tagImageView
{
    if (!_tagImageView) {
        _tagImageView = [UIImageView newAutoLayoutView];
    }
    return _tagImageView;
}
//
//- (UIButton *)tButton
//{
//    if (!_tButton) {
//        _tButton = [UIButton newAutoLayoutView];
//        [_tButton setTitleColor:kLightGrayColor forState:0];
//        _tButton.titleLabel.font = kSecondFont;
//    }
//    return _tButton;
//}

- (UIButton *)goButton
{
    if (!_goButton) {
        _goButton = [UIButton newAutoLayoutView];
//        [_goButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [_goButton swapImage];
        [_goButton setTitleColor:kLightGrayColor forState:0];
        _goButton.titleLabel.font = kSecondFont;
    }
    return _goButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
