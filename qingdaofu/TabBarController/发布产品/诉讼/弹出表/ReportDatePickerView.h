//
//  ReportDatePickerView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportDatePickerView : UIView

@property (nonatomic,strong) void (^didSelectedDate)(NSDate *);

@property (nonatomic,strong) UIButton *finishButton;
@property (nonatomic,strong) UIDatePicker *datePickerView;
@property (nonatomic,strong) UIControl *controll;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
