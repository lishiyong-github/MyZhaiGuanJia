//
//  ExtendHomeCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/22.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ExtendHomeCell.h"

@implementation ExtendHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameButton];
        [self.contentView addSubview:self.typeImageView];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.contentButton];
        [self.contentView addSubview:self.actButton2];
        
        self.bottomContentConstraints = [self.contentButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:42];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.nameButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.nameButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.nameButton autoSetDimension:ALDimensionHeight toSize:21];
        
        [self.typeImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameButton];
        [self.typeImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameButton withOffset:8];
        
        [self.statusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.statusLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeImageView];
        
        [self.contentButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameButton withOffset:kBigPadding];
        [self.contentButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.contentButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        [self.contentButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.actButton2 withOffset:-kSpacePadding];
        
        [self.actButton2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.actButton2 autoSetDimensionsToSize:CGSizeMake(75, 30)];
        [self.actButton2 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kSpacePadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [UIButton newAutoLayoutView];
        [_nameButton setTitleColor:kBlackColor forState:0];
        _nameButton.titleLabel.font = kBigFont;
        _nameButton.userInteractionEnabled = NO;
        _nameButton.userInteractionEnabled = NO;
    }
    return _nameButton;
}

- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [UIImageView newAutoLayoutView];
        _typeImageView.image = [UIImage imageNamed:@"list_more"];
    }
    return _typeImageView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel newAutoLayoutView];
        _statusLabel.textColor = kRedColor;
        _statusLabel.font = kSecondFont;
    }
    return _statusLabel;
}

- (UIButton *)contentButton
{
    if (!_contentButton) {
        _contentButton = [UIButton newAutoLayoutView];
        _contentButton.backgroundColor = UIColorFromRGB(0xf3f7fa);
        _contentButton.titleLabel.numberOfLines = 0;
        [_contentButton setTitleColor:kGrayColor forState:0];
        _contentButton.titleLabel.font = kFirstFont;
        [_contentButton setContentEdgeInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, kBigPadding, kBigPadding)];
        [_contentButton setContentHorizontalAlignment:1];
        _contentButton.userInteractionEnabled = NO;
    }
    return _contentButton;
}

- (UIButton *)actButton2
{
    if (!_actButton2) {
        _actButton2 = [UIButton newAutoLayoutView];
        _actButton2.backgroundColor = kWhiteColor;
        _actButton2.layer.borderWidth = kLineWidth;
        _actButton2.layer.borderColor = kButtonColor.CGColor;
        _actButton2.layer.cornerRadius = corner1;
        [_actButton2 setTitleColor:kTextColor forState:0];
        _actButton2.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _actButton2;
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
