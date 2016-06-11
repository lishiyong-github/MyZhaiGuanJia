//
//  MyAgentCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyAgentCell.h"

@implementation MyAgentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.agentNameLabel];
        [self.contentView addSubview:self.agentEditButton];
        [self.contentView addSubview:self.agentTelLabel];
        [self.contentView addSubview:self.agentIDLabel];
        [self.contentView addSubview:self.agentCerLabel];
        [self.contentView addSubview:self.agentPassLabel];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.agentNameLabel,self.agentTelLabel,self.agentIDLabel,self.agentCerLabel,self.agentPassLabel];
        [views autoAlignViewsToAxis:ALAxisVertical];
        
        [self.agentNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.agentNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.agentEditButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.agentEditButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.agentNameLabel];
        
        [self.agentTelLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.agentTelLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.agentNameLabel withOffset:kSmallPadding];
        
        [self.agentIDLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.agentIDLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.agentTelLabel withOffset:kSmallPadding];
        
        [self.agentCerLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.agentIDLabel withOffset:kSmallPadding];
        [self.agentCerLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.agentPassLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.agentCerLabel withOffset:kSmallPadding];
        [self.agentPassLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];

        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)agentNameLabel
{
    if (!_agentNameLabel) {
        _agentNameLabel = [UILabel newAutoLayoutView];
        _agentNameLabel.font = kBigFont;
    }
    return _agentNameLabel;
}

- (UIButton *)agentEditButton
{
    if (!_agentEditButton) {
        _agentEditButton = [UIButton newAutoLayoutView];
        [_agentEditButton setTitle:@"编辑" forState:0];
        [_agentEditButton setTitleColor:kBlueColor forState:0];
        _agentEditButton.titleLabel.font = kBigFont;
    }
    return _agentEditButton;
}

- (UILabel *)agentTelLabel
{
    if (!_agentTelLabel) {
        _agentTelLabel = [UILabel newAutoLayoutView];
//        _agentTelLabel.textColor = kBlackColor;
        _agentTelLabel.font = kBigFont;
    }
    return _agentTelLabel;
}

- (UILabel *)agentIDLabel
{
    if (!_agentIDLabel) {
        _agentIDLabel = [UILabel newAutoLayoutView];
        //        _agentTelLabel.textColor = kBlackColor;
        _agentIDLabel.font = kBigFont;
    }
    return _agentIDLabel;
}

- (UILabel *)agentCerLabel
{
    if (!_agentCerLabel) {
        _agentCerLabel = [UILabel newAutoLayoutView];
        //        _agentTelLabel.textColor = kBlackColor;
        _agentCerLabel.font = kBigFont;
    }
    return _agentCerLabel;
}

- (UILabel *)agentPassLabel
{
    if (!_agentPassLabel) {
        _agentPassLabel = [UILabel newAutoLayoutView];
        _agentPassLabel.font = kBigFont;
    }
    return _agentPassLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
