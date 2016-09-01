//
//  PropertyResultCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PropertyResultCell.h"

@implementation PropertyResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.showImageView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.showImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstarints = YES;
    }
    [super updateConstraints];
}

- (UIImageView *)showImageView
{
    if (!_showImageView) {
        _showImageView = [UIImageView newAutoLayoutView];
    }
    return _showImageView;
}

@end
