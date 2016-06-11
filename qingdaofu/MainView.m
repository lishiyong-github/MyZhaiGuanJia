//
//  MainView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pubFiSingleButton];
//        [self addSubview:self.pubCoSingleButton];
        [self addSubview:self.pubSuSingleButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.pubFiSingleButton,self.pubCoSingleButton];
//        [views autoAlignViewsToAxis:ALAxisHorizontal];
        [views autoSetViewsDimensionsToSize:CGSizeMake(95, 95+18)];
        
        [self.pubFiSingleButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
        [self.pubFiSingleButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];

        
//        [self.pubCoSingleButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
//        [self.pubCoSingleButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pubFiSingleButton];
        //        [self.pubCoSingleButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
//                [self.pubCoSingleButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        
//        [self.pubSuSingleButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
//        [self.pubSuSingleButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (SingleButton *)pubFiSingleButton
{
    if (!_pubFiSingleButton) {
        _pubFiSingleButton = [SingleButton newAutoLayoutView];
        [_pubFiSingleButton.label setText:@"发布融资"];
        [_pubFiSingleButton.label setTextColor:kNavColor];
        [_pubFiSingleButton addAction:^(UIButton *btn) {
            NSLog(@"发布融资");
        }];
    }
    return _pubFiSingleButton;
}

- (SingleButton *)pubCoSingleButton
{
    if (!_pubCoSingleButton) {
        _pubCoSingleButton = [SingleButton newAutoLayoutView];
        [_pubCoSingleButton.label setTextColor:kNavColor];
        [_pubCoSingleButton.label setText:@"发布催收"];
    }
    return _pubCoSingleButton;
}

- (SingleButton *)pubSuSingleButton
{
    if (!_pubSuSingleButton) {
        _pubSuSingleButton = [SingleButton newAutoLayoutView];
        [_pubSuSingleButton.label setText:@"发布诉讼"];
        [_pubSuSingleButton.label setTextColor:kNavColor];
    }
    return _pubSuSingleButton;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
