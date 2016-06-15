//
//  PaceCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceCell.h"

@implementation PaceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.dateLabel];
        [self addSubview:self.stateLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.separateLabel1];
        [self addSubview:self.separateLabel2];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.dateLabel autoSetDimension:ALDimensionWidth toSize:110];
        [self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.dateLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.stateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateLabel];
        [self.stateLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.dateLabel];
        [self.stateLabel autoSetDimension:ALDimensionWidth toSize:70];
        
        [self.messageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.stateLabel];
        [self.messageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.messageLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.dateLabel];
        
        
        NSArray *views = @[self.separateLabel1,self.separateLabel2];
        [views autoSetViewsDimension:ALDimensionWidth toSize:kLineWidth];

        [self.separateLabel1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateLabel withOffset:-kLineWidth];
        [self.separateLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.separateLabel1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];

        
        [self.separateLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.stateLabel withOffset:-kLineWidth];
        [self.separateLabel2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.separateLabel1];
        [self.separateLabel2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.separateLabel1];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel newAutoLayoutView];
        _dateLabel.textColor = kLightGrayColor;
        _dateLabel.font = kSecondFont;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [UILabel newAutoLayoutView];
        _stateLabel.textColor = kLightGrayColor;
        _stateLabel.font = kSecondFont;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel newAutoLayoutView];
        _messageLabel.textColor = kLightGrayColor;
        _messageLabel.font = kSecondFont;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

-(UILabel *)separateLabel1
{
    if (!_separateLabel1) {
        _separateLabel1 = [UILabel newAutoLayoutView];
        _separateLabel1.backgroundColor = kBlueColor;
        
    }
    return _separateLabel1;
}

-(UILabel *)separateLabel2
{
    if (!_separateLabel2) {
        _separateLabel2 = [UILabel newAutoLayoutView];
        _separateLabel2.backgroundColor = kBlueColor;
        
    }
    return _separateLabel2;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
