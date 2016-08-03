//
//  CopyCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CopyCell.h"

@implementation CopyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imageViewcc];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.soButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.imageViewcc autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.imageViewcc autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageViewcc withOffset:kBigPadding];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        
        [self.phoneLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        [self.phoneLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.soButton withOffset:-kBigPadding];
        
        [self.addressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.nameLabel];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBigPadding];
//        [self.addressLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.soButton withOffset:-kBigPadding];
        
        [self.soButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.soButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)imageViewcc
{
    if (!_imageViewcc) {
        _imageViewcc = [UIImageView newAutoLayoutView];
    }
    return _imageViewcc;
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

- (UIButton *)soButton
{
    if (!_soButton) {
       _soButton =  [UIButton newAutoLayoutView];
        _soButton.titleLabel.font = kSecondFont;
        [_soButton setTitleColor:kLightGrayColor forState:0];
    }
    return _soButton;
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
