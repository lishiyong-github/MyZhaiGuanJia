//
//  DebtCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DebtCell.h"

@implementation DebtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.debtNameLabel];
        [self.contentView addSubview:self.debtEditButton];
        [self.contentView addSubview:self.debtTelLabel];
        [self.contentView addSubview:self.debtAddressLabel];
        [self.contentView addSubview:self.debtAddressLabel1];
        [self.contentView addSubview:self.debtIDLabel];
        [self.contentView addSubview:self.debtImageView1];
        [self.contentView addSubview:self.debtImageView2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.debtNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.debtNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        
        [self.debtEditButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.debtNameLabel];
        [self.debtEditButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.debtTelLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.debtTelLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.debtNameLabel withOffset:kSmallPadding];
        
        [self.debtAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.debtTelLabel withOffset:kSmallPadding];
        [self.debtAddressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.debtAddressLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.debtAddressLabel];
        [self.debtAddressLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:90];
        [self.debtAddressLabel1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.debtIDLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.debtIDLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.debtAddressLabel1 withOffset:kSmallPadding];
        
        [self.debtImageView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.debtIDLabel withOffset:kSmallPadding];
        [self.debtImageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.debtImageView1 autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
        [self.debtImageView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.debtImageView1 withOffset:kBigPadding];
        [self.debtImageView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.debtImageView1];
        [self.debtImageView2 autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)debtNameLabel
{
    if (!_debtNameLabel) {
        _debtNameLabel = [UILabel newAutoLayoutView];
        _debtNameLabel.font = kBigFont;
        _debtNameLabel.textColor = kBlackColor;
    }
    return _debtNameLabel;
}

- (UIButton *)debtEditButton
{
    if (!_debtEditButton) {
        _debtEditButton = [UIButton newAutoLayoutView];
        [_debtEditButton setTitle:@"编辑" forState:0];
        [_debtEditButton setTitleColor:kBlueColor forState:0];
        _debtEditButton.titleLabel.font = kBigFont;
    }
    return _debtEditButton;
}

- (UILabel *)debtTelLabel
{
    if (!_debtTelLabel) {
        _debtTelLabel = [UILabel newAutoLayoutView];
        _debtTelLabel.font = kBigFont;
        _debtTelLabel.textColor = kBlackColor;
    }
    return _debtTelLabel;
}

- (UILabel *)debtAddressLabel
{
    if (!_debtAddressLabel) {
        _debtAddressLabel = [UILabel newAutoLayoutView];
        _debtAddressLabel.font = kBigFont;
        _debtAddressLabel.textColor = kBlackColor;
        _debtAddressLabel.text = @"联系地址";
    }
    return _debtAddressLabel;
}

- (UILabel *)debtAddressLabel1
{
    if (!_debtAddressLabel1) {
        _debtAddressLabel1 = [UILabel newAutoLayoutView];
        _debtAddressLabel1.font = kSecondFont;
        _debtAddressLabel1.textColor = kLightGrayColor;
        _debtAddressLabel1.numberOfLines = 0;
    }
    return _debtAddressLabel1;
}

- (UILabel *)debtIDLabel
{
    if (!_debtIDLabel) {
        _debtIDLabel = [UILabel newAutoLayoutView];
        _debtIDLabel.font = kBigFont;
        _debtIDLabel.textColor = kBlackColor;
    }
    return _debtIDLabel;
}

- (UIImageView *)debtImageView1
{
    if (!_debtImageView1) {
        _debtImageView1 = [UIImageView newAutoLayoutView];
        _debtImageView1.backgroundColor = kLightGrayColor;
    }
    return _debtImageView1;
}

- (UIImageView *)debtImageView2
{
    if (!_debtImageView2) {
        _debtImageView2 = [UIImageView newAutoLayoutView];
        _debtImageView2.backgroundColor = kLightGrayColor;
    }
    return _debtImageView2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
