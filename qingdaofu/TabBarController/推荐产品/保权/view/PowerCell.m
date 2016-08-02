//
//  PowerCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerCell.h"

@implementation PowerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.powerMoneyLabel];
        [self.contentView addSubview:self.powerStateLabel];
        [self.contentView addSubview:self.powerLine];
        [self.contentView addSubview:self.powerButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerMoneyLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.powerMoneyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.powerStateLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.powerMoneyLabel];
        [self.powerStateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UILabel *)powerMoneyLabel
{
    if (!_powerMoneyLabel) {
        _powerMoneyLabel = [UILabel newAutoLayoutView];
        _powerMoneyLabel.numberOfLines = 0;
    }
    return _powerMoneyLabel;
}

- (UILabel *)powerStateLabel
{
    if (!_powerStateLabel) {
        _powerStateLabel = [UILabel newAutoLayoutView];
        [_powerStateLabel setTextColor:kBlackColor];
        _powerStateLabel.font = kFirstFont;
    }
    return _powerStateLabel;
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
