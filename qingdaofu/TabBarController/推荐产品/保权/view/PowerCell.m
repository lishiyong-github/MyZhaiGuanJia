//
//  PowerCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerCell.h"

@implementation PowerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.orderButton];
        [self.contentView addSubview:self.moreImageView];
        [self.contentView addSubview:self.statusLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.orderButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.orderButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.moreImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.orderButton withOffset:kBigPadding];
        [self.moreImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.orderButton];
        
        [self.statusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.statusLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.moreImageView];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)orderButton
{
    if (!_orderButton) {
        _orderButton = [UIButton newAutoLayoutView];
        [_orderButton setTitleColor:kGrayColor forState:0];
        _orderButton.titleLabel.font = kBigFont;
    }
    return _orderButton;
}

- (UIImageView *)moreImageView
{
    if (!_moreImageView) {
        _moreImageView = [UIImageView newAutoLayoutView];
        [_moreImageView setImage:[UIImage imageNamed:@"list_more"]];
    }
    return _moreImageView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel newAutoLayoutView];
        _statusLabel.textColor = kRedColor;
        _statusLabel.font = kSecondFont;
    }
    return _statusLabel;
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
