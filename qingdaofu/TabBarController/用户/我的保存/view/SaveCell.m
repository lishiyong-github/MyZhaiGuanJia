//
//  SaveCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SaveCell.h"

@implementation SaveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.codeButton];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.actButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.codeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        [self.codeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.codeButton withOffset:kSpacePadding];
        
        [self.actButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.actButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)codeButton
{
    if (!_codeButton) {
        _codeButton = [UIButton newAutoLayoutView];
        [_codeButton setTitleColor:kBlackColor forState:0];
        _codeButton.titleLabel.font = kBigFont;
    }
    return _codeButton;
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

- (UIButton *)actButton
{
    if (!_actButton) {
        _actButton = [UIButton newAutoLayoutView];
    }
    return _actButton;
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
