//
//  ReceiptActionCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiptActionCell.h"

@implementation ReceiptActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.reActButton1];
        [self.contentView addSubview:self.reActButton2];
        [self.contentView addSubview:self.reActButton3];
        
        [self setNeedsUpdateConstraints];

    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.reActButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.reActButton1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.reActButton2 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.reActButton3 withOffset:-kBigPadding];
        [self.reActButton2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.reActButton1];
        
        [self.reActButton3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.reActButton3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.reActButton2];

        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)reActButton1
{
    if (!_reActButton1) {
        _reActButton1 = [UIButton newAutoLayoutView];
        _reActButton1.titleLabel.font = kFourFont;
        
        QDFWeakSelf;
        [_reActButton1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedActbutton) {
                weakself.didSelectedActbutton(77,btn);
            }
        }];
    }
    return _reActButton1;
}

- (UIButton *)reActButton2
{
    if (!_reActButton2) {
        _reActButton2 = [UIButton newAutoLayoutView];
        [_reActButton2 setTitleColor:kGrayColor forState:0];
        _reActButton2.titleLabel.font = kFourFont;
        
        QDFWeakSelf;
        [_reActButton2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedActbutton) {
                weakself.didSelectedActbutton(78,btn);
            }
        }];
    }
    return _reActButton2;
}

- (UIButton *)reActButton3
{
    if (!_reActButton3) {
        _reActButton3 = [UIButton newAutoLayoutView];
        [_reActButton3 setTitleColor:kGrayColor forState:0];
        _reActButton3.titleLabel.font = kFourFont;
        
        QDFWeakSelf;
        [_reActButton3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedActbutton) {
                weakself.didSelectedActbutton(79,btn);
            }
        }];
    }
    return _reActButton3;
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
