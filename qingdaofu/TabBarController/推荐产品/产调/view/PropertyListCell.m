//
//  PropertyListCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PropertyListCell.h"

@implementation PropertyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.contentView addSubview:self.spaceLine];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *view = @[self.leftButton,self.rightButton];
        [view autoSetViewsDimension:ALDimensionWidth toSize:kScreenWidth/2];
        
        [self.leftButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        
        [self.rightButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
        
        [self.spaceLine autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.spaceLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.leftButton];
        [self.spaceLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.leftButton];
        [self.spaceLine autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton newAutoLayoutView];
        _leftButton.titleLabel.font = kFirstFont;
        [_leftButton setTitleColor:kBlackColor forState:0];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton newAutoLayoutView];
//        _rightButton.layer.borderColor = kBorderColor.CGColor;
//        _rightButton.layer.borderWidth = kLineWidth;
        _rightButton.titleLabel.font = kFirstFont;
        [_rightButton setTitleColor:kBlackColor forState:0];
    }
    return _rightButton;
}

- (UILabel *)spaceLine
{
    if (!_spaceLine) {
        _spaceLine = [UILabel newAutoLayoutView];
        [_spaceLine setBackgroundColor:kSeparateColor];
    }
    return _spaceLine;
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
