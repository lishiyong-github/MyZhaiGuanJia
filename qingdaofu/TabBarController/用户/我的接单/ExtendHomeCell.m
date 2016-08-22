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
        [self.contentView addSubview:self.typeImageView];
        [self.contentView addSubview:self.nameButton];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.deadLineButton];
        [self.contentView addSubview:self.actButton1];
        [self.contentView addSubview:self.actButton2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.typeImageView autoSetDimensionsToSize:CGSizeMake(41, 21)];
        
        [self.nameButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.typeImageView];
        [self.nameButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeImageView withOffset:8];
        
        [self.statusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.statusLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameButton];
        
        [self.contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeImageView withOffset:kBigPadding];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        [self.contentLabel autoSetDimension:ALDimensionHeight toSize:120];
        [self.contentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.actButton1 withOffset:-7];
        
        [self.deadLineButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.deadLineButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.actButton1];
        
        NSArray *views = @[self.actButton1,self.actButton2];
        [views autoSetViewsDimensionsToSize:CGSizeMake(75, 30)];
        
        [self.actButton1 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.actButton2 withOffset:-kBigPadding];
        [self.actButton1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7];
        
        [self.actButton2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.actButton2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.actButton1];
        [self.actButton2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.actButton1];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [UIImageView newAutoLayoutView];
    }
    return _typeImageView;
}

- (UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [UIButton newAutoLayoutView];
        [_nameButton setTitleColor:kBlackColor forState:0];
        _nameButton.titleLabel.font = kBigFont;
    }
    return _nameButton;
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

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel newAutoLayoutView];
        _contentLabel.backgroundColor = UIColorFromRGB(0xf3f7fa);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = kGrayColor;
        _contentLabel.font = kFirstFont;
    }
    return _contentLabel;
}

- (UIButton *)deadLineButton
{
    if (!_deadLineButton) {
        _deadLineButton = [UIButton newAutoLayoutView];
        [_deadLineButton setTitleColor:kBlueColor forState:0];
        _deadLineButton.titleLabel.font = kSmallFont;
    }
    return _deadLineButton;
}

- (UIButton *)actButton1
{
    if (!_actButton1) {
        _actButton1 = [UIButton newAutoLayoutView];
        _actButton1.layer.borderWidth = kLineWidth;
        _actButton1.layer.borderColor = kBorderColor.CGColor;
        _actButton1.layer.cornerRadius = corner1;
        [_actButton1 setTitleColor:kBlackColor forState:0];
        _actButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _actButton1;
}

- (UIButton *)actButton2
{
    if (!_actButton2) {
        _actButton2 = [UIButton newAutoLayoutView];
        _actButton2.layer.borderWidth = kLineWidth;
        _actButton2.layer.borderColor = kBlueColor.CGColor;
        _actButton2.layer.cornerRadius = corner;
        [_actButton2 setTitleColor:kBlueColor forState:0];
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
