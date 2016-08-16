//
//  PersonCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.pictureButton1];
        [self.contentView addSubview:self.pictureButton2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.pictureButton1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, kBigPadding, 0) excludingEdge:ALEdgeRight];
        [self.pictureButton1 autoSetDimension:ALDimensionWidth toSize:(kScreenWidth - kBigPadding*3)/2];
        
        [self.pictureButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pictureButton1 withOffset:kBigPadding];
        [self.pictureButton2 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, 0, kBigPadding, kBigPadding) excludingEdge:ALEdgeLeft];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)pictureButton1
{
    if (!_pictureButton1) {
        _pictureButton1 = [UIButton newAutoLayoutView];
    }
    return _pictureButton1;
}

- (UIButton *)pictureButton2
{
    if (!_pictureButton2) {
        _pictureButton2 = [UIButton newAutoLayoutView];
    }
    return _pictureButton2;
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
