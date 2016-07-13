//
//  CollectionViewCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.cellImageView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.cellImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [UIImageView newAutoLayoutView];
    }
    return _cellImageView;
}

@end
