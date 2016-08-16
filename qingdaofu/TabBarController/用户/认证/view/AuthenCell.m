//
//  AuthenCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenCell.h"

@interface AuthenCell ()

@property (nonatomic,assign) BOOL bH;

@end

@implementation AuthenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.aImageView];
        [self.contentView addSubview:self.bLabel];
        [self.contentView addSubview:self.cLabel];
        [self.contentView addSubview:self.dLabel];
        [self.contentView addSubview:self.AuthenButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.aImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.aImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, kBigPadding, 0) excludingEdge:ALEdgeRight];
//        [self.aImageView autoSetDimension:ALDimensionWidth toSize:110];
        
        [self.bLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.aImageView];
        [self.bLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.aImageView withOffset:kBigPadding];
        
        [self.cLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bLabel withOffset:kBigPadding/2];
        [self.cLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bLabel];
        
        [self.dLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cLabel withOffset:kBigPadding/2];
        [self.dLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.cLabel];
        
        [self.AuthenButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.bLabel];
        [self.AuthenButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)aImageView
{
    if (!_aImageView) {
        _aImageView = [UIImageView newAutoLayoutView];
        _aImageView.layer.masksToBounds = YES;
    }
    return _aImageView;
}

- (UILabel *)bLabel
{
    if (!_bLabel) {
        _bLabel = [UILabel newAutoLayoutView];
        _bLabel.textColor = kBlackColor;
        _bLabel.font = kBigFont;
        _bLabel.text = @"认证个人";
    }
    return _bLabel;
}

- (UILabel *)cLabel
{
    if (!_cLabel) {
        _cLabel = [UILabel newAutoLayoutView];
        _cLabel.textColor = kLightGrayColor;
        _cLabel.font = kSecondFont;
        _cLabel.text = @"可发布融资";
        _cLabel.numberOfLines = 0;
    }
    return _cLabel;
}

- (UILabel *)dLabel
{
    if (!_dLabel) {
        _dLabel = [UILabel newAutoLayoutView];
        _dLabel.textColor = kLightGrayColor;
        _dLabel.font = kSecondFont;
//        _dLabel.text = @"暂不支持代理";
    }
    return _dLabel;
}

- (UIButton *)AuthenButton
{
    if (!_AuthenButton) {
        _AuthenButton = [UIButton newAutoLayoutView];
        _AuthenButton.titleLabel.font = kSecondFont;
    }
    return _AuthenButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
