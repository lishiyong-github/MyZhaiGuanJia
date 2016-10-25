//
//  SystemMessageCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SystemMessageCell.h"

@implementation SystemMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contenLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleLabel];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.contenLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kSmallPadding];
        [self.contenLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.contenLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.font = kBigFont;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.textColor = kLightGrayColor;
        _timeLabel.font = kSmallFont;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)contenLabel
{
    if (!_contenLabel) {
        _contenLabel = [UILabel newAutoLayoutView];
        _contenLabel.numberOfLines = 0;
    }
    return _contenLabel;
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
