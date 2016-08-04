//
//  ProDetailNumberCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProDetailNumberCell.h"

@implementation ProDetailNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.numberButton1];
        [self.contentView addSubview:self.numberButton2];
        [self.contentView addSubview:self.numberButton3];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.numberButton1,self.numberButton2,self.numberButton3];
        [views autoSetViewsDimension:ALDimensionWidth toSize:kScreenWidth/3];
        [views autoMatchViewsDimension:ALDimensionWidth];
        
        [self.numberButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.numberButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.numberButton1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.numberButton2 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.numberButton2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.numberButton2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.numberButton3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.numberButton3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.numberButton3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];

        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (ProDetailHeadFootView *)numberButton1
{
    if (!_numberButton1) {
        _numberButton1 = [ProDetailHeadFootView newAutoLayoutView];
        _numberButton1.backgroundColor = kNavColor;
        _numberButton1.fLabel1.textColor = kGrayColor;
        _numberButton1.fLabel2.textColor = kBlueColor;
        _numberButton1.fLabel2.font = kFirstFont;
    }
    return _numberButton1;
}

- (ProDetailHeadFootView *)numberButton2
{
    if (!_numberButton2) {
        _numberButton2 = [ProDetailHeadFootView newAutoLayoutView];
        _numberButton2.backgroundColor = kNavColor;
        _numberButton2.fLabel1.textColor = kGrayColor;
        _numberButton2.fLabel2.textColor = kBlueColor;
        _numberButton2.fLabel2.font = kFirstFont;
    }
    return _numberButton2;
}

- (ProDetailHeadFootView *)numberButton3
{
    if (!_numberButton3) {
        _numberButton3 = [ProDetailHeadFootView newAutoLayoutView];
        _numberButton3.backgroundColor = kNavColor;
        _numberButton3.fLabel1.textColor = kGrayColor;
        _numberButton3.fLabel2.textColor = kBlueColor;
        _numberButton3.fLabel2.font = kFirstFont;
    }
    return _numberButton3;
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
