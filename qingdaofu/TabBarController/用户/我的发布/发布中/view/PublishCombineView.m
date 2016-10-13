//
//  PublishCombineView.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PublishCombineView.h"

@implementation PublishCombineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        self.layer.borderColor = kBorderColor.CGColor;
        self.layer.borderWidth = kLineWidth;
        
        [self addSubview:self.comButton1];
        [self addSubview:self.comButton2];
        
        self.topBtnConstraints = [self.comButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.comButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.comButton1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.comButton1 autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        [self.comButton2 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, kBigPadding, kBigPadding, kBigPadding) excludingEdge:ALEdgeTop];
        [self.comButton2 autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)comButton1
{
    if (!_comButton1) {
        _comButton1 = [UIButton newAutoLayoutView];
        _comButton1.titleLabel.font = kFirstFont;
        [_comButton1 setTitle:@"需准备的材料" forState:0];
        [_comButton1 setTitleColor:kWhiteColor forState:0];
    }
    return _comButton1;
}

- (UIButton *)comButton2
{
    if (!_comButton2) {
        _comButton2 = [UIButton newAutoLayoutView];
        _comButton2.titleLabel.font = kFirstFont;
        [_comButton2 setTitle:@"发起面谈" forState:0];
        [_comButton2 setTitleColor:kWhiteColor forState:0];
    }
    return _comButton2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
