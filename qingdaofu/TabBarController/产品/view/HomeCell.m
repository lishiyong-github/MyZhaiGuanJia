//
//  HomeCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.typeImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.recommendimageView];
        
        [self.contentView addSubview:self.typeButton];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.grayLabel];
        [self.contentView addSubview:self.moneyView];
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.rateView];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.typeImageView autoSetDimensionsToSize:CGSizeMake(42, 21)];
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeImageView withOffset:kBigPadding];
        [self.nameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeImageView];
        
        [self.recommendimageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        [self.recommendimageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.recommendimageView autoSetDimensionsToSize:CGSizeMake(40, 40)];
        
        [self.typeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.typeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        
        [self.addressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.typeImageView];
        [self.addressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeImageView withOffset:kSpacePadding];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.grayLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addressLabel withOffset:kSpacePadding];
        [self.grayLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.typeImageView];
        [self.grayLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.grayLabel autoSetDimension:ALDimensionHeight toSize:1];
        
        NSArray *views = @[self.moneyView,self.pointView,self.rateView];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/3, 88)];
        
        [self.moneyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.moneyView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.pointView];
        
        [self.pointView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.grayLabel];
        
        [self.rateView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.rateView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.pointView];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [UIImageView newAutoLayoutView];
    }
    return _typeImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.text = @"RZ201602220001";
        _nameLabel.textColor = kGrayColor;
        _nameLabel.font = kBoldFont(16);
    }
    return _nameLabel;
}

- (UIImageView *)recommendimageView
{
    if (!_recommendimageView) {
        _recommendimageView = [UIImageView newAutoLayoutView];
        _recommendimageView.image = [UIImage imageNamed:@"list_label_recommen"];
    }
    return _recommendimageView;
}

- (UIButton *)typeButton
{
    if (!_typeButton) {
        _typeButton = [UIButton newAutoLayoutView];
    }
    return _typeButton;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel newAutoLayoutView];
        _addressLabel.font = kSmallFont;
        _addressLabel.text = @"抵押物地址：上海市浦东新区浦东南路855号";
        _addressLabel.textColor = kLightGrayColor;
    }
    return _addressLabel;
}

- (UILabel *)grayLabel
{
    if (!_grayLabel) {
        _grayLabel = [UILabel newAutoLayoutView];
        _grayLabel.backgroundColor = kSeparateColor;
    }
    return _grayLabel;
}

- (MoneyView *)moneyView
{
    if (!_moneyView) {
        _moneyView = [MoneyView newAutoLayoutView];
        _moneyView.label1.text = @"80";
        _moneyView.label1.textColor = kYellowColor;
        _moneyView.label1.font = [UIFont systemFontOfSize:22];
        _moneyView.label2.text = @"借款本金";
    }
    return _moneyView;
}

- (MoneyView *)pointView
{
    if (!_pointView) {
        _pointView = [MoneyView newAutoLayoutView];
        _pointView.label1.text = @"5.0%";
        _pointView.label1.font = [UIFont systemFontOfSize:22];
        _pointView.label1.textColor = kBlackColor;
        _pointView.label2.text = @"风险代理(%)";
    }
    return _pointView;
}

- (MoneyView *)rateView
{
    if (!_rateView) {
        _rateView = [MoneyView newAutoLayoutView];
        _rateView.label1.text = @"机动车";
        _rateView.label1.textColor = kGrayColor;
//        _rateView.label1.font = [UIFont systemFontOfSize:22];
        _rateView.label2.text = @"债券类型";
    }
    return _rateView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
