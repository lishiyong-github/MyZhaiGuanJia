//
//  MessageCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview: self.userLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.newsLabel];
        [self.contentView addSubview:self.countLabel];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.userLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.userLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.newsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userLabel withOffset:kSmallPadding];
        [self.newsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userLabel];
        [self.newsLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.countLabel withOffset:-kBigPadding];
        
        [self.countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLabel withOffset:kSmallPadding];
        [self.countLabel autoSetDimensionsToSize:CGSizeMake(18, 18)];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)userLabel
{
    if (!_userLabel) {
        _userLabel = [UILabel newAutoLayoutView];
        _userLabel.font = kBigFont;
        _userLabel.textColor = kBlackColor;
    }
    return _userLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = kLightGrayColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)newsLabel
{
    if (!_newsLabel) {
        _newsLabel = [UILabel newAutoLayoutView];
        _newsLabel.font = kSecondFont;
        _newsLabel.textColor = kLightGrayColor;
    }
    return _newsLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel newAutoLayoutView];
        _countLabel.font = kSecondFont;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = kBlueColor;
        _countLabel.textColor = kNavColor;
        [_countLabel sizeToFit];
    }
    return _countLabel;
}


- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
