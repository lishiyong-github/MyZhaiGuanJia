//
//  EvaTopSwitchView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaTopSwitchView : UIView

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) void (^didSelectedButton)(NSInteger);

@property (nonatomic,strong) UIButton *getbutton;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UILabel *blueLabel;
@property (nonatomic,strong) UILabel *shortLineLabel;
@property (nonatomic,strong) UILabel *longLineLabel;

@property (nonatomic,strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic,strong) NSLayoutConstraint *leftBlueConstraints;

@end
