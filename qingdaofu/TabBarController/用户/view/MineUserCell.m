//
//  MineUserCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MineUserCell.h"
#import "UIButton+Addition.h"

@interface MineUserCell ()
@property (nonatomic,assign) BOOL finishSwap;
@end
@implementation MineUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.userNameButton];
        [self.contentView addSubview:self.userActionButton];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.userNameButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.userNameButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.userActionButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.userActionButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.userNameButton];
//        
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)userNameButton
{
    if (!_userNameButton) {
        _userNameButton = [UIButton newAutoLayoutView];
        _userNameButton.titleLabel.font = kBigFont;
        [_userNameButton setTitleColor:kBlackColor forState:0];
        _userNameButton.userInteractionEnabled = NO;
    }
    return _userNameButton;
}

- (UIButton *)userActionButton
{
    if (!_userActionButton) {
        _userActionButton = [UIButton newAutoLayoutView];
        [_userActionButton swapImage];
        [_userActionButton setTitleColor:kLightGrayColor forState:0];
        _userActionButton.titleLabel.font = kSecondFont;
        _userActionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _userActionButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _userActionButton.userInteractionEnabled = NO;
    }
    return _userActionButton;
}

- (void)swapUserName
{
    if (!self.finishSwap) {
        self.finishSwap = YES;
        [self.userNameButton swapImage];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
