//
//  UserPublishCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UserPublishCell.h"

@implementation UserPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.button1];
        [self.contentView addSubview:self.button2];
        [self.contentView addSubview:self.button3];
        [self.contentView addSubview:self.lined1];
        [self.contentView addSubview:self.lined2];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.button1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [self.button1 autoSetDimension:ALDimensionWidth toSize:kScreenWidth/3];
        
        [self.button2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button1];
        [self.button2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.button1];
        [self.button2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.button1];
        [self.button2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.button1];

        [self.button3 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        [self.button3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.button2];
        
        [self.lined1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.button1 withOffset:kBigPadding];
        [self.lined1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.button1 withOffset:-kBigPadding];
        [self.lined1 autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        [self.lined1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button1];
        
        [self.lined2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button2];
        [self.lined2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.lined1];
        [self.lined2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lined1];
        [self.lined2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lined1];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)button1
{
    if (!_button1) {
        _button1 = [UIButton newAutoLayoutView];
        [_button1 setTitleColor:kBlackColor forState:0];
        _button1.titleLabel.font = kBigFont;
    }
    return _button1;
}

- (UIButton *)button2
{
    if (!_button2) {
        _button2 = [UIButton newAutoLayoutView];
        [_button2 setTitleColor:kBlackColor forState:0];
        _button2.titleLabel.font = kBigFont;
    }
    return _button2;
}

- (UIButton *)button3
{
    if (!_button3) {
        _button3 = [UIButton newAutoLayoutView];
        [_button3 setTitleColor:kBlackColor forState:0];
        _button3.titleLabel.font = kBigFont;
    }
    return _button3;
}

- (UILabel *)lined1
{
    if (!_lined1) {
        _lined1 = [UILabel newAutoLayoutView];
        _lined1.backgroundColor = kBorderColor;
    }
    return _lined1;
}

- (UILabel *)lined2
{
    if (!_lined2) {
        _lined2 = [UILabel newAutoLayoutView];
        _lined2.backgroundColor = kBorderColor;
    }
    return _lined2;
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
