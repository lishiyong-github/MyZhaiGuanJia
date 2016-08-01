//
//  ApplicationSuccessCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationSuccessCell.h"

@implementation ApplicationSuccessCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.appImageView];
        [self.contentView addSubview:self.appLabel1];
        [self.contentView addSubview:self.appLine];
        [self.contentView addSubview:self.appLabel2];
        [self.contentView addSubview:self.appButton1];
        [self.contentView addSubview:self.appButton2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.appImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.appImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.appImageView autoSetDimension:ALDimensionHeight toSize:60];
        [self.appImageView autoSetDimension:ALDimensionWidth toSize:60];
        
        [self.appLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.appImageView withOffset:kBigPadding];
        [self.appLabel1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.appImageView];
        
        [self.appLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.appLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.appLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.appLabel1 withOffset:kBigPadding];
        [self.appLine autoSetDimension:ALDimensionHeight toSize:kLineWidth];
        
        [self.appLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.appLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.appLine withOffset:kBigPadding];
        
        [self.appButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.appButton1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.appLabel2 withOffset:20];
        [self.appButton1 autoSetDimension:ALDimensionWidth toSize:(kScreenWidth-kBigPadding*4)/2];
        [self.appButton1 autoSetDimension:ALDimensionHeight toSize:32];
        
        [self.appButton2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.appButton1];
        [self.appButton2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.appButton2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.appButton1];
        [self.appButton2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.appButton1];

        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)appImageView
{
    if (!_appImageView) {
        _appImageView = [UIImageView newAutoLayoutView];
        _appImageView.layer.masksToBounds = YES;
        _appImageView.backgroundColor = kBlueColor;
    }
    return _appImageView;
}

- (UILabel *)appLabel1
{
    if (!_appLabel1) {
        _appLabel1 = [UILabel newAutoLayoutView];
        _appLabel1.text = @"提交成功";
        _appLabel1.font = [UIFont systemFontOfSize:20];
        _appLabel1.textColor = kBlueColor;
    }
    return _appLabel1;
}

- (LineLabel *)appLine
{
    if (!_appLine) {
        _appLine = [LineLabel newAutoLayoutView];
    }
    return _appLine;
}

- (UILabel *)appLabel2
{
    if (!_appLabel2) {
        _appLabel2 = [UILabel newAutoLayoutView];
        _appLabel2.numberOfLines = 0;
    }
    return _appLabel2;
}

- (UIButton *)appButton1
{
    if (!_appButton1) {
        _appButton1 = [UIButton newAutoLayoutView];
        _appButton1.layer.borderColor = kSeparateColor.CGColor;
        _appButton1.layer.borderWidth = 1;
        [_appButton1 setTitle:@"回首页" forState:0];
        [_appButton1 setTitleColor:kBlackColor forState:0];
        _appButton1.titleLabel.font = kBigFont;
        _appButton1.layer.cornerRadius = corner;
    }
    return _appButton1;
}

- (UIButton *)appButton2
{
    if (!_appButton2) {
        _appButton2 = [UIButton newAutoLayoutView];
        _appButton2.layer.borderColor = kBlueColor.CGColor;
        _appButton2.layer.borderWidth = 1;
        [_appButton2 setTitle:@"我的保函" forState:0];
        [_appButton2 setTitleColor:kBlueColor forState:0];
        _appButton2.titleLabel.font = kBigFont;
        _appButton2.layer.cornerRadius = corner;
    }
    return _appButton2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
