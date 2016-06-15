//
//  BidMessageCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BidMessageCell.h"

@implementation BidMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.deadlineLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.areaLabel];
        [self.contentView addSubview:self.addressLabel];
        
        [self.contentView addSubview:self.remindImageButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.deadlineLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.deadlineLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.deadlineLabel];
        
        [self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.dateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deadlineLabel withOffset:kBigPadding];
        
        [self.areaLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.dateLabel withOffset:kBigPadding];
        [self.areaLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.addressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.areaLabel withOffset:kBigPadding];
        [self.addressLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.remindImageButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)deadlineLabel
{
    if (!_deadlineLabel) {
        _deadlineLabel = [UILabel newAutoLayoutView];
        _deadlineLabel.font = kBigFont;
    }
    return _deadlineLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.textColor = kLightGrayColor;
        _timeLabel.font = kSecondFont;
    }
    return _timeLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel newAutoLayoutView];
        _dateLabel.font = kBigFont;
    }
    return _dateLabel;
}

- (UILabel *)areaLabel
{
    if (!_areaLabel) {
        _areaLabel = [UILabel newAutoLayoutView];
        _areaLabel.font = kBigFont;
    }
    return _areaLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel newAutoLayoutView];
        _addressLabel.font = kBigFont;
    }
    return _addressLabel;
}

- (UIButton *)remindImageButton
{
    if (!_remindImageButton) {
        _remindImageButton = [UIButton newAutoLayoutView];
        [_remindImageButton setImage:[UIImage imageNamed:@"kong"] forState:0];
    }
    return _remindImageButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
