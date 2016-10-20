//
//  NewPublishStateCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewPublishStateCell.h"

@implementation NewPublishStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.stateLabel1];
        [self.contentView addSubview:self.stateButton];
        [self.contentView addSubview:self.stateLabel2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.stateLabel1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.stateLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        [self.stateButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.stateLabel1];
        [self.stateButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stateLabel1 withOffset:kBigPadding];
        [self.stateButton autoSetDimensionsToSize:CGSizeMake(200, 100)];
        
        [self.stateLabel2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.stateButton];
        [self.stateLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stateButton withOffset:kBigPadding];
        
        self.didSetupConstarints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)stateLabel1
{
    if (!_stateLabel1) {
        _stateLabel1 = [UILabel newAutoLayoutView];
        _stateLabel1.font = kNavFont;
        _stateLabel1.textColor = kBlackColor;
        _stateLabel1.text = @"发布成功";
    }
    return _stateLabel1;
}

- (UIButton *)stateButton
{
    if (!_stateButton) {
        _stateButton = [UIButton newAutoLayoutView];
        [_stateButton setBackgroundColor:kLightGrayColor];
        _stateButton.userInteractionEnabled = NO;
    }
    return _stateButton;
}

- (UILabel *)stateLabel2
{
    if (!_stateLabel2) {
        _stateLabel2 = [UILabel newAutoLayoutView];
        _stateLabel2.font = kFourFont;
        _stateLabel2.textColor = kBlackColor;
        _stateLabel2.text = @"选择一个申请方作为意向接单方进行约见面谈";
        _stateLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel2;
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
