//
//  EvaluateSendCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateSendCell.h"

@implementation EvaluateSendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.evaNameLabel];
        [self.contentView addSubview:self.evaTimeLabel];
        [self.contentView addSubview:self.evaStarImageView];
        [self.contentView addSubview:self.evaTextLabel];
        
        [self.contentView addSubview:self.evaProImageViews1];
        [self.contentView addSubview:self.evaProImageViews2];
        
        [self.contentView addSubview:self.evaProductButton];
        [self.contentView addSubview:self.evaDeleteButton];
        [self.contentView addSubview:self.evaAdditionButton];
        
        [self setNeedsUpdateConstraints];
        
        self.topProConstraints = [self.evaProductButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.evaNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kSmallPadding];
        
        [self.evaTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.evaTimeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.evaNameLabel];
        
        [self.evaStarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaStarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaNameLabel withOffset:kSmallPadding];
        [self.evaStarImageView autoSetDimensionsToSize:CGSizeMake(60, 12)];
        
        [self.evaTextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaStarImageView withOffset:kSmallPadding];
        [self.evaTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.evaProImageViews1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaProImageViews1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaTextLabel withOffset:kSmallPadding];
        [self.evaProImageViews1 autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
        [self.evaProImageViews2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.evaProImageViews1 withOffset:kBigPadding];
        [self.evaProImageViews2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.evaProImageViews1];
        [self.evaProImageViews2 autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
        [self.evaProductButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaProductButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.evaProductButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.evaInnnerButton autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
        [self.evaInnnerButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kSmallPadding];
        [self.evaInnnerButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.evaInnerImage withOffset:-kBigPadding];
        
        [self.evaInnerImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.evaInnerImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.evaInnnerButton];
        
        [self.evaDeleteButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.evaDeleteButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.evaAdditionButton];
        
        [self.evaAdditionButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.evaAdditionButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.evaProductButton withOffset:kBigPadding];
        [self.evaAdditionButton autoSetDimensionsToSize:CGSizeMake(75, 25)];
        
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

- (LEOStarView *)evaStarImageView
{
    if (!_evaStarImageView) {
        _evaStarImageView = [LEOStarView newAutoLayoutView];
        //        _evaStarImage.currentIndex = 4;
        _evaStarImageView.starImage = [UIImage imageNamed:@"publish_star"];
        _evaStarImageView.markType = EMarkTypeInteger;
        _evaStarImageView.starFrontColor = kBlueColor;
        _evaStarImageView.starBackgroundColor = UIColorFromRGB(0xeeeeee);
        _evaStarImageView.userInteractionEnabled = NO;
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

- (UIButton *)evaProImageViews1
{
    if (!_evaProImageViews1) {
        _evaProImageViews1 = [UIButton newAutoLayoutView];
    }
    return _evaProImageViews1;
}

- (UIButton *)evaProImageViews2
{
    if (!_evaProImageViews2) {
        _evaProImageViews2 = [UIButton newAutoLayoutView];
        [_evaProImageViews2 setBackgroundColor:kRedColor];
    }
    return _evaProImageViews2;
}

- (UIButton *)evaProductButton
{
    if (!_evaProductButton) {
        _evaProductButton = [UIButton newAutoLayoutView];
        _evaProductButton.layer.borderWidth = kLineWidth;
        _evaProductButton.layer.borderColor = kLightGrayColor.CGColor;
        
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

- (UIButton *)evaDeleteButton
{
    if (!_evaDeleteButton) {
        _evaDeleteButton = [UIButton newAutoLayoutView];
        [_evaDeleteButton setTitleColor:kRedColor forState:0];
//        [_evaDeleteButton setTitle:@"删除" forState:0];
        _evaDeleteButton.titleLabel.font = kFirstFont;
        
        QDFWeakSelf;
        [_evaDeleteButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedIndex) {
                weakself.didSelectedIndex(444);
            }
        }];
    }
    return _evaDeleteButton;
}

- (UIButton *)evaAdditionButton
{
    if (!_evaAdditionButton) {
        _evaAdditionButton = [UIButton newAutoLayoutView];
        _evaAdditionButton.layer.borderWidth = kLineWidth;
        _evaAdditionButton.layer.borderColor = kBlueColor.CGColor;
//        [_evaAdditionButton setTitle:@"追加评价" forState:0];
        [_evaAdditionButton setTitleColor:kBlueColor forState:0];
        _evaAdditionButton.titleLabel.font = kFirstFont;
        QDFWeakSelf;
        [_evaAdditionButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedIndex) {
                weakself.didSelectedIndex(445);
            }
        }];
    }
    return _evaAdditionButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
