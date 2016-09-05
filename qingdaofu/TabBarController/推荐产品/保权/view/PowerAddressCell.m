//
//  PowerAddressCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerAddressCell.h"

@implementation PowerAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.actButton];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        
        [self.phoneLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.actButton];
        [self.phoneLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.addressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:kSmallPadding];
        [self.addressLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.actButton];
        
        [self.actButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.actButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.actButton autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.font = kBigFont;
        _nameLabel.textColor = kBlackColor;
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel newAutoLayoutView];
        _phoneLabel.font = kBigFont;
        _phoneLabel.textColor = kBlackColor;
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel newAutoLayoutView];
        _addressLabel.font = kSecondFont;
        _addressLabel.textColor = kGrayColor;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIButton *)actButton
{
    if (!_actButton) {
        _actButton = [UIButton newAutoLayoutView];
    }
    return _actButton;
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
