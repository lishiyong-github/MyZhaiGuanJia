//
//  NewsCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.typeButton];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contextLabel];
        [self.contentView addSubview:self.goTobutton];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.typeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.typeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeButton];
        
        [self.contextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeButton withOffset:5];
        [self.contextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.contextLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.goTobutton withOffset:-kBigPadding];
        
        [self.goTobutton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.goTobutton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contextLabel];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)typeButton
{
    if (!_typeButton) {
        _typeButton = [UIButton newAutoLayoutView];
        [_typeButton setTitleColor:kBlackColor forState:0];
        _typeButton.titleLabel.font = kBigFont;
    }
    return _typeButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.textColor = kLightGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:10];
    }
    return _timeLabel;
}

- (UILabel *)contextLabel
{
    if (!_contextLabel) {
        _contextLabel = [UILabel newAutoLayoutView];
        _contextLabel.textColor = kLightGrayColor;
        _contextLabel.font = kSecondFont;
    }
    return _contextLabel;
}

- (UIButton *)goTobutton
{
    if (!_goTobutton) {
        _goTobutton = [UIButton newAutoLayoutView];
        [_goTobutton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//        _goTobutton.titleLabel.font = kBigFont;
    }
    return _goTobutton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
