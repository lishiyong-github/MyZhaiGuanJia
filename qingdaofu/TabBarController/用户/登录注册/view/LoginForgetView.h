//
//  LoginForgetView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseCommitButton.h"

@interface LoginForgetView : UIView

@property (nonatomic,strong) BaseCommitButton *loginCommitButton;
@property (nonatomic,strong) UIButton *forgrtButton;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) void (^didSelecBtn)(NSInteger);
@end
