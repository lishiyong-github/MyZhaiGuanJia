//
//  ProDetailCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/8.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProDetailCell.h"

@implementation ProDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.deRateLabel];
        [self.contentView addSubview:self.deRateLabel1];
        
        [self.contentView addSubview:self.deMoneyView];
        [self.contentView addSubview:self.deTypeView];
        [self.contentView addSubview:self.deLineLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.deRateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.deRateLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.deRateLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deRateLabel withOffset:20];
        [self.deRateLabel1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.deRateLabel];
        
        [self.deMoneyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deRateLabel1 withOffset:25];
        [self.deMoneyView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.deMoneyView autoSetDimension:ALDimensionWidth toSize:kScreenWidth/2];
        [self.deMoneyView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.deTypeView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.deMoneyView];
        [self.deTypeView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.deMoneyView];
        [self.deTypeView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.deTypeView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.deLineLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.deMoneyView withOffset:kBigPadding];
        [self.deLineLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.deMoneyView];
        [self.deLineLabel autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        [self.deLineLabel autoSetDimension:ALDimensionHeight toSize:45];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)deRateLabel
{
    if (!_deRateLabel) {
        _deRateLabel = [UILabel newAutoLayoutView];
        _deRateLabel.font = kSecondFont;
        _deRateLabel.textColor = UIColorFromRGB(0xbdcae3);
        _deRateLabel.text = @"代理费率";
    }
    return _deRateLabel;
}

- (UILabel *)deRateLabel1
{
    if (!_deRateLabel1) {
        _deRateLabel1 = [UILabel newAutoLayoutView];
        _deRateLabel1.textColor = kNavColor;
        _deRateLabel1.font = [UIFont systemFontOfSize:50];  //24
    }
    return _deRateLabel1;
}

- (ProDetailHeadFootView *)deMoneyView
{
    if (!_deMoneyView) {
        _deMoneyView = [ProDetailHeadFootView newAutoLayoutView];
        _deMoneyView.backgroundColor = kNavColor1;
    }
    return _deMoneyView;
}

- (UILabel *)deLineLabel
{
    if (!_deLineLabel) {
        _deLineLabel = [UILabel newAutoLayoutView];
        _deLineLabel.backgroundColor = kNavColor;
    }
    return _deLineLabel;
}

- (ProDetailHeadFootView *)deTypeView
{
    if (!_deTypeView) {
        _deTypeView = [ProDetailHeadFootView newAutoLayoutView];
        _deTypeView.backgroundColor = kNavColor1;
        _deTypeView.fLabel2.font = kBigFont;
//        _deTypeView.fLabel1.text = @"债权类型";
//        _deTypeView.fLabel2.text = @"应收帐款";
    }
    return _deTypeView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
