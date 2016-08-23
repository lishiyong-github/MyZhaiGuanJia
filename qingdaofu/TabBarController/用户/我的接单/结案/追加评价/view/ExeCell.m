//
//  ExeCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ExeCell.h"

@implementation ExeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.ceButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.ceButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.ceButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.ceButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}
- (UIButton *)ceButton
{
    if (!_ceButton) {
        _ceButton = [UIButton newAutoLayoutView];
        [_ceButton setTitleColor:kBlackColor forState:0];
        _ceButton.titleLabel.font = kBigFont;
        [_ceButton setContentHorizontalAlignment:1];
    }
    return _ceButton;
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
