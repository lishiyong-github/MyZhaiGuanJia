//
//  AnotherHomeCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AnotherHomeCell.h"

@implementation AnotherHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.typeImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeLabel];
        
        [self.contentView addSubview:self.typeButton];
        
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.grayLabel];
        [self.contentView addSubview:self.moneyView];
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.rateView];
        [self.contentView addSubview:self.lineLabel2];
        [self.contentView addSubview:self.firstButton];
        [self.contentView addSubview:self.secondButton];
        [self.contentView addSubview:self.thirdButton];
        
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
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeImageView withOffset:kBigPadding];
        [self.nameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeImageView];
        
        [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.typeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        
        [self.typeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.typeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        
        [self.addressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.typeImageView];
        [self.addressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeImageView withOffset:10];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.grayLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addressLabel withOffset:10];
        [self.grayLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.typeImageView];
        [self.grayLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.grayLabel autoSetDimension:ALDimensionHeight toSize:1];
        
        NSArray *views = @[self.moneyView,self.pointView,self.rateView];
        [views autoSetViewsDimensionsToSize:CGSizeMake(kScreenWidth/3, 88)];
        
        [self.moneyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.moneyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.grayLabel];
        
        [self.pointView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.moneyView];
        
        [self.rateView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.rateView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.moneyView];
        
        [self.lineLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.moneyView];
        [self.lineLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.lineLabel2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.lineLabel2 autoSetDimension:ALDimensionHeight toSize:kLineWidth];
        
        NSArray *views3 = @[self.firstButton,self.secondButton,self.thirdButton];
        [views3 autoAlignViewsToAxis:ALAxisHorizontal];
        
        NSArray *views4 = @[self.secondButton,self.thirdButton];
        [views4 autoSetViewsDimensionsToSize:CGSizeMake(75, 25)];
        
        [self.firstButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.secondButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineLabel2 withOffset:9.5];
        [self.secondButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.thirdButton withOffset:-10];
        
        [self.thirdButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];

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

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel newAutoLayoutView];
        _typeLabel.font = kSecondFont;
        _typeLabel.textColor = kBlueColor;
    }
    return _typeLabel;
}

- (UIButton *)typeButton
{
    if (!_typeButton) {
        _typeButton = [UIButton newAutoLayoutView];
        [_typeButton setTitleColor:kBlueColor forState:0];
        _typeButton.titleLabel.font = kSecondFont;
    }
    return _typeButton;
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

- (LineLabel *)grayLabel
{
    if (!_grayLabel) {
        _grayLabel = [LineLabel newAutoLayoutView];
    }
    return _grayLabel;
}

- (MoneyView *)moneyView
{
    if (!_moneyView) {
        _moneyView = [MoneyView newAutoLayoutView];
        _moneyView.label1.text = @"80";
        _moneyView.label1.textColor = kYellowColor;
        _moneyView.label2.text = @"借款本金(万元)";
    }
    return _moneyView;
}

- (MoneyView *)pointView
{
    if (!_pointView) {
        _pointView = [MoneyView newAutoLayoutView];
        _pointView.label1.text = @"5.0%";
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

- (LineLabel *)lineLabel2
{
    if (!_lineLabel2) {
        _lineLabel2 = [LineLabel newAutoLayoutView];
    }
    return _lineLabel2;
}

- (UIButton *)firstButton
{
    if (!_firstButton) {
        _firstButton = [UIButton newAutoLayoutView];
        _firstButton.titleLabel.font = kSecondFont;
        [_firstButton setTitleColor:kRedColor forState:0];
    }
    return _firstButton;
}

- (UIButton *)secondButton
{
    if (!_secondButton) {
        _secondButton = [UIButton newAutoLayoutView];
        [_secondButton setTitleColor:kBlackColor forState:0];
        _secondButton.titleLabel.font = kFirstFont;
        _secondButton.layer.borderColor = kLightGrayColor.CGColor;
        _secondButton.layer.borderWidth = kLineWidth;
    }
    return _secondButton;
}

- (UIButton *)thirdButton
{
    if (!_thirdButton) {
        _thirdButton = [UIButton newAutoLayoutView];
        [_thirdButton setTitleColor:kBlueColor forState:0];
        _thirdButton.titleLabel.font = kFirstFont;
        _thirdButton.layer.borderColor = kBlueColor.CGColor;
        _thirdButton.layer.borderWidth = kLineWidth;
    }
    return _thirdButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
