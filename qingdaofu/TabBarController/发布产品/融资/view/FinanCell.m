//
//  FinanCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "FinanCell.h"

@implementation FinanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.typeButton];
        [self.contentView addSubview:self.rentLabel];
        [self.contentView addSubview:self.rentTextField];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
        
        [self.typeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.typeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeLabel];
        
        [self.rentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.rentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:13];
        
        [self.rentTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
        [self.rentTextField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.rentLabel];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel newAutoLayoutView];
        _typeLabel.textColor = kBlackColor;
        _typeLabel.font = kBigFont;
    }
    return _typeLabel;
}

- (UIButton *)typeButton
{
    if (!_typeButton) {
        _typeButton = [UIButton newAutoLayoutView];
        [_typeButton swapImage];
        [_typeButton setTitleColor:kBlueColor forState:0];
        _typeButton.titleLabel.font = kSecondFont;
    }
    return _typeButton;
}

- (UILabel *)rentLabel
{
    if (!_rentLabel) {
        _rentLabel = [UILabel newAutoLayoutView];
        _rentLabel.textColor = kBlackColor;
        _rentLabel.font = kBigFont;
    }
    return _rentLabel;
}

- (UITextField *)rentTextField
{
    if (!_rentTextField) {
        _rentTextField = [UITextField newAutoLayoutView];
        _rentTextField.textColor = kBlackColor;
        _rentTextField.font = kBigFont;
    }
    return _rentTextField;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
