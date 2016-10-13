//
//  OrderPublishCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OrderPublishCell.h"

@implementation OrderPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.checkButton];
        [self.contentView addSubview:self.listLabel];
        [self.contentView addSubview:self.contactButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.checkButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [self.checkButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.listLabel withOffset:1];
        
        [self.listLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.contactButton withOffset:-kBigPadding];
        [self.listLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
        [self.listLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
        [self.listLabel autoSetDimension:ALDimensionWidth toSize:kLineWidth];
        
        [self.contactButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.contactButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)checkButton
{
    if (!_checkButton) {
        _checkButton = [UIButton newAutoLayoutView];
        _checkButton.backgroundColor = kWhiteColor;
        [_checkButton setContentEdgeInsets:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        _checkButton.contentHorizontalAlignment = 1;
        [_checkButton setTitle:@"发布方" forState:0];
        [_checkButton setTitleColor:kBlackColor forState:0];
        _checkButton.titleLabel.font = kBigFont;
        
        UIImageView *moreImageView = [UIImageView newAutoLayoutView];
        moreImageView.image = [UIImage imageNamed:@"list_more"];
        [_checkButton addSubview:moreImageView];
        
        [moreImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [moreImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return _checkButton;
}


- (UILabel *)listLabel
{
    if (!_listLabel) {
        _listLabel = [UILabel newAutoLayoutView];
        _listLabel.backgroundColor = kSeparateColor;
    }
    return _listLabel;
}

- (UIButton *)contactButton
{
    if (!_contactButton) {
        _contactButton = [UIButton newAutoLayoutView];
        _contactButton.titleLabel.font = kFirstFont;
        [_contactButton setTitleColor:kBlackColor forState:0];
    }
    return _contactButton;
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
