//
//  UpCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UpCell.h"

@implementation UpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.upButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.upButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)upButton
{
    if (!_upButton) {
        _upButton = [UIButton newAutoLayoutView];
        [_upButton setTitleColor:kLightGrayColor forState:0];
        [_upButton setTitleColor:kBlueColor forState:UIControlStateSelected];
        _upButton.titleLabel.font = kSecondFont;
    }
    return _upButton;
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
