//
//  AllProSegView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllProSegView : UIView

@property (nonatomic,strong) UIButton *allButton;
@property (nonatomic,strong) UIButton *ingButton;
@property (nonatomic,strong) UIButton *dealButton;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong) UILabel *tBlueLabel;

@property (nonatomic,strong) NSLayoutConstraint *leftsConstraints;

@property (nonatomic,strong) void (^didSelectedSeg)(NSInteger);

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
