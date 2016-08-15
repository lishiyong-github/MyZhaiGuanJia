//
//  ProductsView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/15.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsView.h"

@implementation ProductsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionButton];
        [self addSubview:self.suitButton];
        [self addSubview:self.kLabel];
        
        self.leftConstraints = [self.kLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.collectionButton withOffset:0];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        NSArray *views = @[self.collectionButton,self.suitButton];
        [views autoSetViewsDimensionsToSize:CGSizeMake(60, 44)];
        
        [self.collectionButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.collectionButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];

        [self.suitButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.suitButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.kLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [self.kLabel autoSetDimension:ALDimensionHeight toSize:2];
        [self.kLabel autoSetDimension:ALDimensionWidth toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)collectionButton
{
    if (!_collectionButton) {
        _collectionButton = [UIButton newAutoLayoutView];
        _collectionButton.titleLabel.font = kNavFont;
        [_collectionButton setTitle:@"清收" forState:0];
        [_collectionButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_collectionButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedBtn) {
                weakself.leftConstraints.constant = 0;
                
                [btn setTitleColor:kBlueColor forState:0];
                [weakself.suitButton setTitleColor:kBlackColor forState:0];
                
                weakself.didSelectedBtn(101);
            }
        }];
    }
    return _collectionButton;
}

- (UIButton *)suitButton
{
    if (!_suitButton) {
        _suitButton = [UIButton newAutoLayoutView];
        _suitButton.titleLabel.font = kNavFont;
        [_suitButton setTitle:@"诉讼" forState:0];
        [_suitButton setTitleColor:kBlackColor forState:0];
        
        QDFWeakSelf;
        [_suitButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedBtn) {
                weakself.leftConstraints.constant = 60;
                
                [btn setTitleColor:kBlueColor forState:0];
                [weakself.collectionButton setTitleColor:kBlackColor forState:0];

                weakself.didSelectedBtn(102);
            }
        }];
    }
    return _suitButton;
}

- (UILabel *)kLabel
{
    if (!_kLabel) {
        _kLabel = [UILabel newAutoLayoutView];
        _kLabel.backgroundColor = kBlueColor;
    }
    return _kLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
