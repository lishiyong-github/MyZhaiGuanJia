//
//  MiAlertView.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MiAlertView.h"

@interface MiAlertView ()

@property (nonatomic,strong) UIButton *alertbutton1;
@property (nonatomic,strong) UIButton *alertbutton2;
@property (nonatomic,strong) UIButton *alertbutton3;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation MiAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.alertbutton1];
        [self addSubview:self.alertbutton2];
        [self addSubview:self.alertbutton3];
        
        [self setNeedsUpdateConstraints];

    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.alertbutton1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
        [self.alertbutton2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.alertbutton1 withOffset: kBigPadding];
        [self.alertbutton2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.alertbutton2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.alertbutton3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.alertbutton2 withOffset: kBigPadding];
        [self.alertbutton3 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)alertbutton1
{
    if (!_alertbutton1) {
        _alertbutton1 = [UIButton newAutoLayoutView];
        _alertbutton1.titleLabel.font = kSecondFont;
    }
    return _alertbutton1;
}

- (UIButton *)alertbutton2
{
    if (!_alertbutton2) {
        _alertbutton2 = [UIButton newAutoLayoutView];
        _alertbutton2.titleLabel.font = kSecondFont;
        [_alertbutton2 setTitleColor:kBlackColor forState:0];
        _alertbutton2.titleLabel.numberOfLines = 0;
        _alertbutton2.contentEdgeInsets = UIEdgeInsetsMake(0, kSpacePadding, 0, kSpacePadding);
        _alertbutton2.contentHorizontalAlignment = 1;
    }
    return _alertbutton2;
}

- (UIButton *)alertbutton3
{
    if (!_alertbutton3) {
        _alertbutton3 = [UIButton newAutoLayoutView];
        [_alertbutton3 setTitleColor:kBlueColor forState:0];
        _alertbutton3.titleLabel.font = kBigFont;
    }
    return _alertbutton3;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
