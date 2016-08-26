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
        [self.contentView addSubview:self.lined];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.button1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [self.button1 autoSetDimension:ALDimensionWidth toSize:kScreenWidth/2];
        
        [self.button2 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        [self.button2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.button1];
        
        [self.lined autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.button1];
        [self.lined autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.button1];
        [self.lined autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.lined autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
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

- (UILabel *)lined
{
    if (!_lined) {
        _lined = [UILabel newAutoLayoutView];
        _lined.backgroundColor = kBorderColor;
    }
    return _lined;
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
