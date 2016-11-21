
//
//  ProgressCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProgressCell.h"

@implementation ProgressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.ppLine1];
        [self.contentView addSubview:self.ppLabel];
        [self.contentView addSubview:self.ppImageView];
        [self.contentView addSubview:self.ppLine2];
        
        [self.contentView addSubview:self.ppTextButton];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.ppLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ppLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.ppLabel autoSetDimension:ALDimensionWidth toSize:70];
        
        [self.ppLine1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.ppLine1 autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        [self.ppLine1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.ppImageView];
        [self.ppLine1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.ppImageView];
        
        [self.ppImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.ppLabel withOffset:kSpacePadding];
        [self.ppImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.ppLabel];
        [self.ppImageView autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        
        [self.ppLine2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.ppLine1];
        [self.ppLine2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ppImageView];
        [self.ppLine2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.ppLine1];
        [self.ppLine2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.ppTextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.ppImageView withOffset:kBigPadding];
        [self.ppTextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.ppTextButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)ppLine1
{
    if (!_ppLine1) {
        _ppLine1 = [UILabel newAutoLayoutView];
        _ppLine1.backgroundColor = kSeparateColor;
    }
    return _ppLine1;
}

- (UILabel *)ppLabel
{
    if (!_ppLabel) {
        _ppLabel = [UILabel newAutoLayoutView];
        _ppLabel.numberOfLines = 0;
    }
    return _ppLabel;
}

- (UIImageView *)ppImageView
{
    if (!_ppImageView) {
        _ppImageView = [UIImageView newAutoLayoutView];
        [_ppImageView setBackgroundColor:kRedColor];
    }
    return _ppImageView;
}

- (UIButton *)ppTextButton
{
    if (!_ppTextButton) {
        _ppTextButton = [UIButton newAutoLayoutView];
        _ppTextButton.titleLabel.numberOfLines = 0;
    }
    return _ppTextButton;
}

- (UILabel *)ppLine2
{
    if (!_ppLine2) {
        _ppLine2 = [UILabel newAutoLayoutView];
        _ppLine2.backgroundColor = kSeparateColor;
    }
    return _ppLine2;
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
