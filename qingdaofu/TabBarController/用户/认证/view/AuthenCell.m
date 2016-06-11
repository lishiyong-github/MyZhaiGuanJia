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
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.aImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
        [self.aImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.aImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        
        [self.bLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
        [self.bLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.aImageView withOffset:20];
        
        [self.cLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bLabel withOffset:20];
        [self.cLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bLabel];
        
        [self.dLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cLabel withOffset:10];
        [self.dLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.cLabel];
        
        [self.AuthenButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.AuthenButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.AuthenButton autoSetDimensionsToSize:CGSizeMake(70, 35)];
        
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
        _bLabel.font = [UIFont systemFontOfSize:17];
        _bLabel.text = @"认证个人";
    }
    return _bLabel;
}

- (UILabel *)cLabel
{
    if (!_cLabel) {
        _cLabel = [UILabel newAutoLayoutView];
        _cLabel.textColor = kLightGrayColor;
        _cLabel.font = kFirstFont;
        _cLabel.text = @"可发布融资";
    }
    return _cLabel;
}

- (UILabel *)dLabel
{
    if (!_dLabel) {
        _dLabel = [UILabel newAutoLayoutView];
        _dLabel.textColor = kLightGrayColor;
        _dLabel.font = kFirstFont;
//        _dLabel.text = @"暂不支持代理";
    }
    return _dLabel;
}

- (UIButton *)AuthenButton
{
    if (!_AuthenButton) {
        _AuthenButton = [UIButton newAutoLayoutView];
        _AuthenButton.backgroundColor = kBlueColor;
        _AuthenButton.layer.cornerRadius = corner;
        [_AuthenButton setTitle:@"立即认证" forState:0];
        _AuthenButton.titleLabel.font = kFirstFont;
        [_AuthenButton setTitleColor:kNavColor forState:0];
        [_AuthenButton addAction:^(UIButton *btn) {
            NSLog(@"立即认证");
        }];
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
