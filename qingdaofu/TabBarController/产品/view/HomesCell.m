//
//  HomesCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HomesCell.h"

@implementation HomesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        
        [self.contentView addSubview:self.typeLabel1];
        [self.contentView addSubview:self.typeLabel2];
        [self.contentView addSubview:self.typeLabel3];
        [self.contentView addSubview:self.typeLabel4];

        [self.contentView addSubview:self.moneyView];
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.rateView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.addressLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        
        NSArray *views1 = @[self.typeLabel1,self.typeLabel2,self.typeLabel3,self.typeLabel4];
        [views1 autoAlignViewsToAxis:ALAxisHorizontal];
        [views1 autoSetViewsDimension:ALDimensionHeight toSize:15];
        
        [self.typeLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.typeLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:kSpacePadding];
        
        [self.typeLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeLabel1 withOffset:kBigPadding];
        
        [self.typeLabel3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeLabel2 withOffset:kBigPadding];

        [self.typeLabel4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeLabel3 withOffset:kBigPadding];
        
        NSArray *views2 = @[self.moneyView,self.pointView,self.rateView];
        [views2 autoSetViewsDimension:ALDimensionWidth toSize:kScreenWidth/3];
        [views2 autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.moneyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.moneyView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.pointView];
        
        [self.pointView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeLabel1 withOffset:kSpacePadding];
        [self.pointView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.rateView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.rateView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.pointView];

        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.text = @"RZ201602220001";
        _nameLabel.textColor = kGrayColor;
        _nameLabel.font = kFirstFont;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel newAutoLayoutView];
        _addressLabel.font = kSecondFont;
        _addressLabel.text = @"上海上海市浦东新区";
        _addressLabel.textColor = kLightGrayColor;
    }
    return _addressLabel;
}

- (UILabel *)typeLabel1
{
    if (!_typeLabel1) {
        _typeLabel1 = [UILabel newAutoLayoutView];
        _typeLabel1.layer.borderColor = kBorderColor.CGColor;
        _typeLabel1.layer.borderWidth = kLineWidth;
        _typeLabel1.layer.cornerRadius = corner;
        _typeLabel1.text = @" 房产抵押 ";
        _typeLabel1.textColor = kBlackColor;
        _typeLabel1.font = kTabBarFont;
    }
    return _typeLabel1;
}

- (UILabel *)typeLabel2
{
    if (!_typeLabel2) {
        _typeLabel2 = [UILabel newAutoLayoutView];
        _typeLabel2.layer.borderColor = kBorderColor.CGColor;
        _typeLabel2.layer.borderWidth = kLineWidth;
        _typeLabel2.layer.cornerRadius = corner;
        _typeLabel2.text = @" 机动车抵押 ";
        _typeLabel2.textColor = kBlackColor;
        _typeLabel2.font = kTabBarFont;
    }
    return _typeLabel2;
}

- (UILabel *)typeLabel3
{
    if (!_typeLabel3) {
        _typeLabel3 = [UILabel newAutoLayoutView];
        _typeLabel3.layer.borderColor = kBorderColor.CGColor;
        _typeLabel3.layer.borderWidth = kLineWidth;
        _typeLabel3.layer.cornerRadius = corner;
        _typeLabel3.text = @" 合同纠纷 ";
        _typeLabel3.textColor = kBlackColor;
        _typeLabel3.font = kTabBarFont;
    }
    return _typeLabel3;
}

- (UILabel *)typeLabel4
{
    if (!_typeLabel4) {
        _typeLabel4 = [UILabel newAutoLayoutView];
        _typeLabel4.layer.borderColor = kBorderColor.CGColor;
        _typeLabel4.layer.borderWidth = kLineWidth;
        _typeLabel4.layer.cornerRadius = corner;
        _typeLabel4.text = @" 抵押 ";
        _typeLabel4.textColor = kBlackColor;
        _typeLabel4.font = kTabBarFont;
    }
    return _typeLabel4;
}

- (MoneyView *)moneyView
{
    if (!_moneyView) {
        _moneyView = [MoneyView newAutoLayoutView];
        _moneyView.label1.text = @"80万";
        _moneyView.label1.textColor = kYellowColor;
        _moneyView.label1.font = [UIFont systemFontOfSize:22];
        _moneyView.label2.text = @"委托费用";
    }
    return _moneyView;
}

- (MoneyView *)pointView
{
    if (!_pointView) {
        _pointView = [MoneyView newAutoLayoutView];
        _pointView.label1.text = @"100万";
        _pointView.label1.font = [UIFont systemFontOfSize:22];
        _pointView.label1.textColor = kTextColor;
        _pointView.label2.text = @"委托金额";
    }
    return _pointView;
}

- (MoneyView *)rateView
{
    if (!_rateView) {
        _rateView = [MoneyView newAutoLayoutView];
        _rateView.label1.text = @"3个月";
        _rateView.label1.textColor = kTextColor;
        _rateView.label2.text = @"违约期限";
    }
    return _rateView;
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
