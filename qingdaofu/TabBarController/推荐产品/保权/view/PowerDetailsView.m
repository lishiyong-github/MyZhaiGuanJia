//
//  PowerDetailsView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerDetailsView.h"

@implementation PowerDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kNavColor;
        
        [self addSubview:self.applyButton];
        [self addSubview:self.checkButton];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.checkButton,self.applyButton];
        [views autoSetViewsDimensionsToSize:CGSizeMake(70, 40)];
        
        [self.applyButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.checkButton withOffset:-kBigPadding];
        [self.applyButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.checkButton];
        
        [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [self.checkButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)applyButton
{
    if (!_applyButton) {
        _applyButton = [UIButton newAutoLayoutView];
        _applyButton.titleLabel.font = kFirstFont;
        _applyButton.layer.cornerRadius = corner;
    }
    return _applyButton;
}

- (UIButton *)checkButton
{
    if (!_checkButton) {
        _checkButton = [UIButton newAutoLayoutView];
        _checkButton.titleLabel.font = kFirstFont;
        _checkButton.layer.cornerRadius = corner;
    }
    return _checkButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
