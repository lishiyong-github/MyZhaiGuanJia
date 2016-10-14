//
//  RequestEndCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RequestEndCell.h"

@implementation RequestEndCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.reasonButton1];
        [self.contentView addSubview:self.reasonButton2];
        [self.contentView addSubview:self.reasonButton3];
        [self.contentView addSubview:self.reasonButton4];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.reasonButton1,self.reasonButton2,self.reasonButton3,self.reasonButton4];
        [views autoSetViewsDimension:ALDimensionWidth toSize:128];
        
        [self.reasonButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.reasonButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.reasonButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.reasonButton1 withOffset:kNewPadding];
        [self.reasonButton2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.reasonButton1];
        
        [self.reasonButton3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.reasonButton1 withOffset:kBigPadding];
        [self.reasonButton3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        
        [self.reasonButton4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.reasonButton3 withOffset:kNewPadding];
        [self.reasonButton4 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.reasonButton3];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)reasonButton1
{
    if (!_reasonButton1) {
        _reasonButton1 = [UIButton newAutoLayoutView];
        [_reasonButton1 setTitle:@"材料复核有问题" forState:0];
        [_reasonButton1 setTitleColor:kBlackColor forState:0];
        [_reasonButton1 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _reasonButton1.titleLabel.font = kFirstFont;
        [_reasonButton1 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_reasonButton1 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        _reasonButton1.tag = 11;
        
        QDFWeakSelf;
        [_reasonButton1 addAction:^(UIButton *btn) {
            weakself.reasonButton2.selected = NO;
            weakself.reasonButton3.selected = NO;
            weakself.reasonButton4.selected = NO;

            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];
    }
    return _reasonButton1;
}

- (UIButton *)reasonButton2
{
    if (!_reasonButton2) {
        _reasonButton2 = [UIButton newAutoLayoutView];
        [_reasonButton2 setTitle:@"佣金协商不统一" forState:0];
        [_reasonButton2 setTitleColor:kBlackColor forState:0];
        [_reasonButton2 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _reasonButton2.titleLabel.font = kFirstFont;
        [_reasonButton2 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_reasonButton2 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        _reasonButton2.tag = 12;
        
        QDFWeakSelf;
        [_reasonButton2 addAction:^(UIButton *btn) {
            
            weakself.reasonButton1.selected = NO;
            weakself.reasonButton3.selected = NO;
            weakself.reasonButton4.selected = NO;
            
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];

    }
    return _reasonButton2;
}

- (UIButton *)reasonButton3
{
    if (!_reasonButton3) {
        _reasonButton3 = [UIButton newAutoLayoutView];
        [_reasonButton3 setTitle:@"面谈不愉快" forState:0];
        [_reasonButton3 setTitleColor:kBlackColor forState:0];
        [_reasonButton3 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _reasonButton3.titleLabel.font = kFirstFont;
        [_reasonButton3 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_reasonButton3 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        _reasonButton3.tag = 13;

        QDFWeakSelf;
        [_reasonButton3 addAction:^(UIButton *btn) {
            weakself.reasonButton1.selected = NO;
            weakself.reasonButton2.selected = NO;
            weakself.reasonButton4.selected = NO;

            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];

    }
    return _reasonButton3;
}

- (UIButton *)reasonButton4
{
    if (!_reasonButton4) {
        _reasonButton4 = [UIButton newAutoLayoutView];
        [_reasonButton4 setTitle:@"其他" forState:0];
        [_reasonButton4 setTitleColor:kBlackColor forState:0];
        [_reasonButton4 setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _reasonButton4.titleLabel.font = kFirstFont;
        [_reasonButton4 setBackgroundImage:[UIImage imageNamed:@"buttons"] forState:0];
        [_reasonButton4 setBackgroundImage:[UIImage imageNamed:@"buttons_s"] forState:UIControlStateSelected];
        _reasonButton4.tag = 14;

        QDFWeakSelf;
        [_reasonButton4 addAction:^(UIButton *btn) {
            weakself.reasonButton1.selected = NO;
            weakself.reasonButton2.selected = NO;
            weakself.reasonButton3.selected = NO;

            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(btn);
            }
            btn.selected = !btn.selected;
        }];
    }
    return _reasonButton4;
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
