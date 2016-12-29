//
//  FourProductView.m
//  qingdaofu
//
//  Created by zhixiang on 16/12/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "FourProductView.h"

@implementation FourProductView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.functionButton1];
        [self addSubview:self.functionButton2];
        [self addSubview:self.functionButton3];
        [self addSubview:self.functionButton4];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        NSArray *views = @[self.functionButton1,self.functionButton2,self.functionButton3,self.functionButton4];
        [views autoSetViewsDimension:ALDimensionWidth toSize:kScreenWidth/4];
        
        [views autoMatchViewsDimension:ALDimensionWidth];
        [views autoAlignViewsToAxis:ALAxisHorizontal];
        
        [self.functionButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [self.functionButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.functionButton1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.functionButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.functionButton1];
        [self.functionButton2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        [self.functionButton3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.functionButton2];
        [self.functionButton3 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        [self.functionButton4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.functionButton3];
        [self.functionButton4 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (SingleButton *)functionButton1
{
    if (!_functionButton1) {
        _functionButton1 = [SingleButton newAutoLayoutView];
        _functionButton1.label.text = @"诉讼保全";
        [_functionButton1.button setImage:[UIImage imageNamed:@"home_preservation"] forState:0];
        _functionButton1.button.userInteractionEnabled = NO;
        
        QDFWeakSelf;
        [_functionButton1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(11);
            }
        }];
    }
    return _functionButton1;
}

- (SingleButton *)functionButton2
{
    if (!_functionButton2) {
        _functionButton2 = [SingleButton newAutoLayoutView];
        _functionButton2.label.text = @"申请保函";
        [_functionButton2.button setImage:[UIImage imageNamed:@"home_letter"] forState:0];
        _functionButton2.button.userInteractionEnabled = NO;
        QDFWeakSelf;
        [_functionButton2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(12);
            }
        }];
    }
    return _functionButton2;
}

- (SingleButton *)functionButton3
{
    if (!_functionButton3) {
        _functionButton3 = [SingleButton newAutoLayoutView];
        _functionButton3.label.text = @"房产评估";
        [_functionButton3.button setImage:[UIImage imageNamed:@"home_property"] forState:0];
        _functionButton3.button.userInteractionEnabled = NO;
        
        QDFWeakSelf;
        [_functionButton3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(13);
            }
        }];
    }
    return _functionButton3;
}

- (SingleButton *)functionButton4
{
    if (!_functionButton4) {
        _functionButton4 = [SingleButton newAutoLayoutView];
        _functionButton4.label.text = @"产调查询";
        [_functionButton4.button setImage:[UIImage imageNamed:@"home_production"] forState:0];//btn_financing
        _functionButton4.button.userInteractionEnabled = NO;
        
        QDFWeakSelf;
        [_functionButton4 addAction:^(UIButton *btn) {
            if (weakself.didSelectedItem) {
                weakself.didSelectedItem(14);
            }
        }];
    }
    return _functionButton4;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
