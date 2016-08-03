//
//  BidOneCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BidOneCell.h"

@implementation BidOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.oneButton];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.cancelButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.oneButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.oneButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton newAutoLayoutView];
        _cancelButton.titleLabel.font = kBigFont;
        [_cancelButton setTitleColor:kBlackColor forState:0];
    }
    return _cancelButton;
}

- (UIButton *)oneButton
{
    if (!_oneButton) {
        _oneButton = [UIButton newAutoLayoutView];
        _oneButton.titleLabel.font = kBigFont;
        [_oneButton setTitleColor:kBlueColor forState:0];
        [_oneButton swapImage];
        _oneButton.titleLabel.numberOfLines = 0;
    }
    return _oneButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
