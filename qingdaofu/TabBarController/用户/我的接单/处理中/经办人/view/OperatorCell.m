//
//  OperatorCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OperatorCell.h"

@implementation OperatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.aabutton];
        [self.contentView addSubview:self.bbButton];
        [self.contentView addSubview:self.ccButton];
        [self.contentView addSubview:self.ddButton];
        
        self.leftBBButtonConstraints = [self.bbButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:34];
//        [self.bbButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.aabutton withOffset:kSpacePadding];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.aabutton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.aabutton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.bbButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.aabutton];
        [self.bbButton autoSetDimensionsToSize:CGSizeMake(24, 24)];
        
        [self.ccButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.bbButton withOffset:kSpacePadding];
        [self.ccButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.bbButton];
        
        [self.ddButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.ddButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.ccButton];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)aabutton
{
    if (!_aabutton) {
        _aabutton = [UIButton newAutoLayoutView];
        _aabutton.userInteractionEnabled = NO;
    }
    return _aabutton;
}

- (UIButton *)bbButton
{
    if (!_bbButton) {
        _bbButton = [UIButton newAutoLayoutView];
        _bbButton.layer.borderColor = kBorderColor.CGColor;
        _bbButton.layer.borderWidth = kLineWidth;
        _bbButton.layer.cornerRadius = 12;
        _bbButton.layer.masksToBounds = YES;
        _bbButton.userInteractionEnabled = NO;
    }
    return _bbButton;
}

- (UIButton *)ccButton
{
    if (!_ccButton) {
        _ccButton = [UIButton newAutoLayoutView];
        [_ccButton setTitleColor:kBlackColor forState:0];
        _ccButton.titleLabel.font = kBigFont;
        _ccButton.userInteractionEnabled = NO;
    }
    return _ccButton;
}

- (UIButton *)ddButton
{
    if (!_ddButton) {
        _ddButton = [UIButton newAutoLayoutView];
    }
    return _ddButton;
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
