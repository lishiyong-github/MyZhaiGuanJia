//
//  MessageTableViewCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imageButton];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.timeButton];
        [self.contentView addSubview:self.contentLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.imageButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.imageButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.imageButton autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
        [self.countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.imageButton];
        [self.countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.imageButton];
        [self.countLabel autoSetDimensionsToSize:CGSizeMake(16, 16)];
        
        [self.contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageButton withOffset:kSpacePadding];
        [self.contentLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.imageButton];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
        
        [self.timeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.timeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentLabel];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)imageButton
{
    if (!_imageButton) {
        _imageButton = [UIButton newAutoLayoutView];
        _imageButton.backgroundColor = kRedColor;
    }
    return _imageButton;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel newAutoLayoutView];
        _countLabel.backgroundColor = kYellowColor;
        _countLabel.font = kSmallFont;
        _countLabel.layer.cornerRadius = 8;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textColor = kWhiteColor;
        _countLabel.textAlignment = 1;
    }
    return _countLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel newAutoLayoutView];
        _contentLabel.textColor = kBlackColor;
//        _contentLabel.text = @"1221221";
    }
    return _contentLabel;
}

- (UIButton *)timeButton
{
    if (!_timeButton) {
        _timeButton = [UIButton newAutoLayoutView];
//        [_timeButton setTitle:@"新进度" forState:0];
        [_timeButton setTitleColor:kYellowColor forState:0];
        _timeButton.titleLabel.font = kFirstFont;
        [_timeButton swapImage];
    }
    return _timeButton;
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
