//
//  CompletePhotoView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompletePhotoView.h"

@implementation CompletePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.label];
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.label autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        
        NSArray *views = @[self.button1,self.button2];
        [views autoSetViewsDimensionsToSize:CGSizeMake(55, 55)];
        
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:105];
        
        [self.button2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.button1];
        [self.button2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button1 withOffset:15];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel newAutoLayoutView];
        _label.textColor = kBlackColor;
        _label.font = kBigFont;
    }
    return _label;
}

- (UIButton *)button1
{
    if (!_button1) {
        _button1 = [UIButton newAutoLayoutView];
        _button1.layer.cornerRadius = corner;
        _button1.layer.masksToBounds = YES;
        _button1.layer.borderColor = kLightGrayColor.CGColor;
        _button1.layer.borderWidth = kLineWidth;
    }
    return _button1;
}

- (UIButton *)button2
{
    if (!_button2) {
        _button2 = [UIButton newAutoLayoutView];
        _button2.layer.cornerRadius = corner;
        _button2.layer.masksToBounds = YES;
        _button2.layer.borderColor = kLightGrayColor.CGColor;
        _button2.layer.borderWidth = kLineWidth;
    }
    return _button2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
