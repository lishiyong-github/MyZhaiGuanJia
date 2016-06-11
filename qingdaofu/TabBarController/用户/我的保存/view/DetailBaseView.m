//
//  DetailBaseView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DetailBaseView.h"

@implementation DetailBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.imageView1];
        [self addSubview:self.label1];
        [self addSubview:self.button1];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = @[self.imageView1,self.label1,self.button1];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.5];
        [self.imageView1 autoSetDimensionsToSize:CGSizeMake(21, 21)];
        
        [self.label1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageView1 withOffset:kSmallPadding];
        
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)imageView1
{
    if (!_imageView1) {
        _imageView1 = [UIImageView newAutoLayoutView];
    }
    return _imageView1;
}

- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [UILabel newAutoLayoutView];
        _label1.textColor = kBlackColor;
        _label1.font = kBigFont;
    }
    return _label1;
}

- (UIButton *)button1
{
    if (!_button1) {
        _button1 = [UIButton newAutoLayoutView];
        [_button1 setTitleColor:kLightGrayColor forState:0];
        _button1.titleLabel.font = kSecondFont;
//        [_button2 setImage:[UIImage imageNamed:@"list_more"] forState:0];
    }
    return _button1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
