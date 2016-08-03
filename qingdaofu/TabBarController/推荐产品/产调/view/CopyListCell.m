//
//  CopyListCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CopyListCell.h"

@implementation CopyListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.editButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        
        [self.phoneLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        [self.phoneLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.line withOffset:-kBigPadding];
        
        [self.addressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.nameLabel];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBigPadding];
        [self.addressLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.phoneLabel];
        
        [self.line autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.editButton withOffset:-kBigPadding];
        [self.line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBigPadding];
        [self.line autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
        [self.editButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.editButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
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

- (UILabel *)line
{
    if (!_line) {
        _line = [UILabel newAutoLayoutView];
        _line.backgroundColor = kBorderColor;
    }
    return _line;
}

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton =  [UIButton newAutoLayoutView];
        _editButton.titleLabel.font = kBigFont;
        [_editButton setTitleColor:kBlueColor forState:0];
    }
    return _editButton;
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
