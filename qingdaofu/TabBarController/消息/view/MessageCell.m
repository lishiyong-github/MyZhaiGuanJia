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
        [self.contentView addSubview:self.actButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.userLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.userLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.userLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding*2+45];
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSpacePadding];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.newsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userLabel withOffset:kBigPadding];
        [self.newsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userLabel];
        [self.newsLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.countLabel withOffset:-kBigPadding];
        
//        [self.countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
//        [self.countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLabel withOffset:kSmallPadding];
//        [self.countLabel autoSetDimensionsToSize:CGSizeMake(18, 18)];
        
        [self.countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.actButton withOffset:5];
        [self.countLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.newsLabel];
        [self.countLabel autoSetDimensionsToSize:CGSizeMake(18, 18)];
        
        [self.actButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.actButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.newsLabel];
        
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
        _timeLabel.font = [UIFont systemFontOfSize:13];
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

- (UIButton *)actButton
{
    if (!_actButton) {
        _actButton = [UIButton newAutoLayoutView];
        [_actButton setTitleColor:kNavColor forState:0];
        _actButton.titleLabel.font = kSecondFont;
        _actButton.backgroundColor = kBlueColor;
    }
    return _actButton;
}


- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
