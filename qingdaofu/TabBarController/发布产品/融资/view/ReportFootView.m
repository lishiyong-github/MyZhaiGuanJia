//
//  ReportFootView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportFootView.h"

@implementation ReportFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.footButton];
        [self addSubview:self.footLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.footButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
        [self.footButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.footButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.footLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.footButton withOffset:kSmallPadding];
        [self.footLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.footLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)footButton
{
    if (!_footButton) {
        _footButton = [UIButton newAutoLayoutView];
        [_footButton setImage:[UIImage imageNamed:@"open"] forState:0];
        [_footButton setImage:[UIImage imageNamed:@"withdraw"] forState:UIControlStateSelected];
        
        NSMutableAttributedString *aStr1 = [[NSMutableAttributedString alloc] initWithString:@"展开补充信息(选填)"];
        [aStr1 addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, aStr1.length)];
        [_footButton setAttributedTitle:aStr1 forState:0];

        NSMutableAttributedString *aStr2 = [[NSMutableAttributedString alloc] initWithString:@"收回补充信息(选填)"];
        [aStr2 addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, aStr2.length)];
        [_footButton setAttributedTitle:aStr2 forState:UIControlStateSelected];
    }
    return _footButton;
}

- (UILabel *)footLabel
{
    if (!_footLabel) {
        _footLabel = [UILabel newAutoLayoutView];
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.textColor = kNavColor;
        _footLabel.font = [UIFont systemFontOfSize:10];
        _footLabel.text = @"信息越完整越容易获得接单方的青睐";
    }
    return _footLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
