//
//  EvaluateCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateCell.h"

@implementation EvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.evaNameLabel];
        [self.contentView addSubview:self.evaTimeLabel];
        [self.contentView addSubview:self.evaStarImageView];
        [self.contentView addSubview:self.evaTextLabel];
        [self.contentView addSubview:self.evaProductButton];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.evaNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        
        [self.evaTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.evaTimeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.evaNameLabel];
        
        [self.evaStarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaStarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaNameLabel withOffset:kSmallPadding];
        [self.evaStarImageView autoSetDimensionsToSize:CGSizeMake(80, 15)];
        
        [self.evaTextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaStarImageView withOffset:kBigPadding];
        [self.evaTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.evaProductButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaProductButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaTextLabel withOffset:kBigPadding];
        [self.evaProductButton autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        [self.evaProductButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.evaInnnerButton autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
        [self.evaInnnerButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kSmallPadding];
        [self.evaInnnerButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.evaInnerImage withOffset:-kBigPadding];
        
        [self.evaInnerImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.evaInnerImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.evaInnnerButton];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)evaNameLabel
{
    if (!_evaNameLabel) {
        _evaNameLabel = [UILabel newAutoLayoutView];
        _evaNameLabel.textColor = kBlueColor;
        _evaNameLabel.font = kBigFont;
    }
    return _evaNameLabel;
}

- (UILabel *)evaTimeLabel
{
    if (!_evaTimeLabel) {
        _evaTimeLabel = [UILabel newAutoLayoutView];
        _evaTimeLabel.textColor = kLightGrayColor;
        _evaTimeLabel.font = kTabBarFont;
    }
    return _evaTimeLabel;
}

- (UIImageView *)evaStarImageView
{
    if (!_evaStarImageView) {
        _evaStarImageView = [UIImageView newAutoLayoutView];
        _evaStarImageView.backgroundColor = kYellowColor;
    }
    return _evaStarImageView;
}
    
- (UILabel *)evaTextLabel
{
    if (!_evaTextLabel) {
        _evaTextLabel = [UILabel newAutoLayoutView];
        _evaTextLabel.textColor = kBlackColor;
        _evaTextLabel.font = kFirstFont;
    }
    return _evaTextLabel;
}

- (UIButton *)evaProductButton
{
    if (!_evaProductButton) {
        _evaProductButton = [UIButton newAutoLayoutView];
        _evaProductButton.layer.borderWidth = kLineWidth;
        _evaProductButton.layer.borderColor = kGrayColor.CGColor;
        
        [_evaProductButton addSubview:self.evaInnnerButton];
        [_evaProductButton addSubview:self.evaInnerImage];
    }
    return _evaProductButton;
}

- (UIButton *)evaInnnerButton
{
    if (!_evaInnnerButton) {
        _evaInnnerButton = [UIButton newAutoLayoutView];
        [_evaInnnerButton setTitleColor:kLightGrayColor forState:0];
        _evaInnnerButton.titleLabel.font = kFirstFont;
        [_evaInnnerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kSmallPadding, 0, 0)];
        _evaInnnerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _evaInnnerButton.userInteractionEnabled = NO;
    }
    return _evaInnnerButton;
}

- (UIImageView *)evaInnerImage
{
    if (!_evaInnerImage) {
        _evaInnerImage = [UIImageView newAutoLayoutView];
        [_evaInnerImage setImage:[UIImage imageNamed:@"list_more"]];
    }
    return _evaInnerImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
