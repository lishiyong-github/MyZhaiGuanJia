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
        [self.contentView addSubview:self.typeLabel];
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
        [self.typeImageView autoSetDimensionsToSize:CGSizeMake(40, 18)];
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeImageView withOffset:10];
        [self.nameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeImageView];
        
        [self.recommendimageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.recommendimageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.recommendimageView autoSetDimensionsToSize:CGSizeMake(35, 35)];
        
        [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.typeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        
        [self.addressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.typeImageView];
        [self.addressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeImageView withOffset:10];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.grayLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addressLabel withOffset:10];
        [self.grayLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.typeImageView];
        [self.grayLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.grayLabel autoSetDimension:ALDimensionHeight toSize:1];
        
        NSArray *views = @[self.moneyView,self.pointView,self.rateView];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/3, self.moneyView.aH)];
        
        [self.moneyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.moneyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.grayLabel];
        
        [self.pointView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.moneyView];
        
        [self.rateView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.rateView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.moneyView];
        
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
        _nameLabel.font = kSecondFont;
        _nameLabel.text = @"RZ201602220001";
        _nameLabel.textColor = kGrayColor;
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

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel newAutoLayoutView];
        _typeLabel.font = kSecondFont;
        _typeLabel.textColor = kBlueColor;
    }
    return _typeLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel newAutoLayoutView];
        _addressLabel.font = kSecondFont;
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
        _moneyView.label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        _moneyView.label2.text = @"借款本金(万元)";
    }
    return _moneyView;
}

- (MoneyView *)pointView
{
    if (!_pointView) {
        _pointView = [MoneyView newAutoLayoutView];
        _pointView.label1.text = @"5.0%";
//        _pointView.label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        _pointView.label1.textColor = kBlackColor;
        _pointView.label2.text = @"风险代理";
    }
    return _pointView;
}

- (MoneyView *)rateView
{
    if (!_rateView) {
        _rateView = [MoneyView newAutoLayoutView];
        _rateView.label1.text = @"机动车";
        _rateView.label1.textColor = kBlueColor;
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
