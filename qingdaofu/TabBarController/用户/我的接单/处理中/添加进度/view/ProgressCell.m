
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
        [self.contentView addSubview:self.ppTypeButton];
        [self.contentView addSubview:self.ppLine2];
        
        [self.contentView addSubview:self.ppTextButton];
        
        self.leftTextConstraints = [self.ppTextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.ppTypeButton withOffset:kBigPadding];


        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.ppLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ppLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.ppLabel autoSetDimension:ALDimensionWidth toSize:50];
        
        [self.ppLine1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.ppLine1 autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        [self.ppLine1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.ppTypeButton];
        [self.ppLine1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.ppTypeButton];
        
        [self.ppTypeButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.ppLabel withOffset:kSpacePadding];
        [self.ppTypeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.ppLabel];
        [self.ppTypeButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        
        [self.ppLine2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.ppLine1];
        [self.ppLine2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.ppTypeButton];
        [self.ppLine2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.ppLine1];
        [self.ppLine2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.ppTextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.ppTextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.ppLabel];
        
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

- (UIButton *)ppTypeButton
{
    if (!_ppTypeButton) {
        _ppTypeButton = [UIButton newAutoLayoutView];
        [_ppTypeButton setTitleColor:kWhiteColor forState:0];
        _ppTypeButton.layer.cornerRadius = 10;
        _ppTypeButton.titleLabel.font = kFourFont;
    }
    return _ppTypeButton;
}

- (UIButton *)ppTextButton
{
    if (!_ppTextButton) {
        _ppTextButton = [UIButton newAutoLayoutView];
        _ppTextButton.titleLabel.numberOfLines = 0;
        _ppTextButton.titleLabel.font = kFirstFont;
        [_ppTextButton setTitleColor:kLightGrayColor forState:0];
        [_ppTextButton setContentHorizontalAlignment:1];
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
