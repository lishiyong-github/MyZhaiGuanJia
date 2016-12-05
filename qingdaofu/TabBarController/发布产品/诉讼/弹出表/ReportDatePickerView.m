//
//  ReportDatePickerView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReportDatePickerView.h"

@implementation ReportDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        self.tag = 1010;
        
        [self addSubview:self.finishButton];
        [self addSubview:self.datePickerView];
        [self addSubview:self.controll];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.finishButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.datePickerView];
        [self.finishButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.finishButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.finishButton autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.datePickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.datePickerView autoSetDimension:ALDimensionHeight toSize:160];
        
        [self.controll autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.controll autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.finishButton];

        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton newAutoLayoutView];
        _finishButton.backgroundColor = kWhiteColor;
        [_finishButton setTitle:@"完成" forState:0];
        [_finishButton setTitleColor:kBlackColor forState:0];
        _finishButton.titleLabel.font = kFirstFont;
        _finishButton.layer.borderColor = kBorderColor.CGColor;
        _finishButton.layer.borderWidth = kLineWidth;
        _finishButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kBigPadding);
        _finishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        QDFWeakSelf;
        [_finishButton addAction:^(UIButton *btn) {
            [weakself hiddenDateViews];
            if (weakself.didSelectedDate) {
                weakself.didSelectedDate(weakself.datePickerView.date);
            }
        }];
    }
    return _finishButton;
}

- (UIDatePicker *)datePickerView
{
    if (!_datePickerView) {
        _datePickerView = [UIDatePicker newAutoLayoutView];
        _datePickerView.backgroundColor = kWhiteColor;
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        _datePickerView.maximumDate = [NSDate date];
    }
    return _datePickerView;
}

- (UIControl *)controll
{
    if (!_controll) {
        _controll = [UIControl newAutoLayoutView];
        [_controll addTarget:self action:@selector(hiddenDateViews) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controll;
}

- (void)hiddenDateViews
{
    UIView *ioCView = [self viewWithTag:1010];
//    [ioCView removeFromSuperview];
    [ioCView setHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
