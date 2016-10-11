//
//  BaseCommitButton.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseCommitButton.h"

@implementation BaseCommitButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kButtonColor;
        self.titleLabel.font = kFirstFont;
        [self setTitleColor:kWhiteColor forState:0];
        self.layer.cornerRadius = corner1;
    }
    return self;
}

- (void)updateConstraints
{
    if (self.didSetupconstraints) {
        
//        [self.phoneButton autoPinEdgeToSuperviewMargin:ALEdgeTop];
//        [self.phoneButton autoPinEdgeToSuperviewMargin:ALEdgeLeft];
//        [self.phoneButton autoPinEdgeToSuperviewMargin:ALEdgeBottom];
//        [self.phoneButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
        
//        [self.phoneButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//        [self.phoneButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
//        [self.phoneButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//        [self.phoneButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
        
//        [self.phoneButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
//        [self.phoneButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
//        [self.phoneButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
//        [self.phoneButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];

        self.didSetupconstraints = YES;
    }
    [super updateConstraints];
}

//- (UIButton *)phoneButton
//{
//    if (!_phoneButton) {
//        _phoneButton = [UIButton newAutoLayoutView];
//        [_phoneButton setImage:[UIImage imageNamed:@"phone"] forState:0];
//        _phoneButton.backgroundColor = kBlueColor;
//    }
//    return _phoneButton;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
