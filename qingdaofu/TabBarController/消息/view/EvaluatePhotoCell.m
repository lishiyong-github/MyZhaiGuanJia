//
//  EvaluatePhotoCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluatePhotoCell.h"

@implementation EvaluatePhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.evaNameButton];
        [self.contentView addSubview:self.evaNameLabel];
        [self.contentView addSubview:self.evaTimeLabel];
        [self.contentView addSubview:self.evaStarImage];
        [self.contentView addSubview:self.evaTextLabel];
        [self.contentView addSubview:self.evaProImageView1];
        [self.contentView addSubview:self.evaProImageView2];
        
        self.topTextConstraints = [self.evaStarImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaNameButton withOffset:kSpacePadding];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.evaNameButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaNameButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSpacePadding];
        [self.evaNameButton autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        [self.evaNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.evaNameButton withOffset:kBigPadding];
        [self.evaNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.evaNameButton];
        
        [self.evaTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.evaTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.evaNameButton];
        
        [self.evaStarImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaStarImage autoSetDimensionsToSize:CGSizeMake(60, kBigPadding)];
        
        [self.evaTextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaStarImage withOffset:kSpacePadding];
        [self.evaTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.evaProImageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaProImageView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaTextLabel withOffset:10];
        [self.evaProImageView1 autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
        [self.evaProImageView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.evaProImageView1 withOffset:kBigPadding];
        [self.evaProImageView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.evaProImageView1];
        [self.evaProImageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.evaProImageView1];
        [self.evaProImageView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.evaProImageView1];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}


- (UIButton *)evaNameButton
{
    if (!_evaNameButton) {
        _evaNameButton = [UIButton newAutoLayoutView];
        _evaNameButton.layer.cornerRadius = 15;
        _evaNameButton.layer.masksToBounds = YES;
    }
    return _evaNameButton;
}

- (UILabel *)evaNameLabel
{
    if (!_evaNameLabel) {
        _evaNameLabel = [UILabel newAutoLayoutView];
        _evaNameLabel.textColor = kGrayColor;
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

- (LEOStarView *)evaStarImage
{
    if (!_evaStarImage) {
        _evaStarImage = [LEOStarView newAutoLayoutView];
        _evaStarImage.starImage = [UIImage imageNamed:@"publish_star"];
        _evaStarImage.markType = EMarkTypeInteger;
        _evaStarImage.starFrontColor = kYellowColor;
        _evaStarImage.starBackgroundColor = UIColorFromRGB(0xeeeeee);
        _evaStarImage.userInteractionEnabled = NO;
    }
    return _evaStarImage;
}

- (UILabel *)evaTextLabel
{
    if (!_evaTextLabel) {
        _evaTextLabel = [UILabel newAutoLayoutView];
        _evaTextLabel.textColor = kLightGrayColor;
        _evaTextLabel.font = kSecondFont;
    }
    return _evaTextLabel;
}

- (UIButton *)evaProImageView1
{
    if (!_evaProImageView1) {
        _evaProImageView1 = [UIButton newAutoLayoutView];
    }
    return _evaProImageView1;
}

- (UIButton *)evaProImageView2
{
    if (!_evaProImageView2) {
        _evaProImageView2 = [UIButton newAutoLayoutView];
    }
    return _evaProImageView2;
}

//- (UIButton *)evaProductButton
//{
//    if (!_evaProductButton) {
//        _evaProductButton = [UIButton newAutoLayoutView];
//        _evaProductButton.layer.borderWidth = kLineWidth;
//        _evaProductButton.layer.borderColor = kGrayColor.CGColor;
//
//        [_evaProductButton addSubview:self.evaInnnerButton];
//        [_evaProductButton addSubview:self.evaInnerImage];
//    }
//    return _evaProductButton;
//}
//
//- (UIButton *)evaInnnerButton
//{
//    if (!_evaInnnerButton) {
//        _evaInnnerButton = [UIButton newAutoLayoutView];
//        [_evaInnnerButton setTitleColor:kLightGrayColor forState:0];
//        _evaInnnerButton.titleLabel.font = kFirstFont;
//        [_evaInnnerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kSmallPadding, 0, 0)];
//        _evaInnnerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _evaInnnerButton.userInteractionEnabled = NO;
//    }
//    return _evaInnnerButton;
//}
//
//- (UIImageView *)evaInnerImage
//{
//    if (!_evaInnerImage) {
//        _evaInnerImage = [UIImageView newAutoLayoutView];
//        [_evaInnerImage setImage:[UIImage imageNamed:@"list_more"]];
//    }
//    return _evaInnerImage;
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
