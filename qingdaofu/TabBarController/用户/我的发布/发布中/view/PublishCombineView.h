//
//  PublishCombineView.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishCombineView : UIView

@property (nonatomic,strong) void (^didSelectedBtn)(NSInteger);
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *comButton1;
@property (nonatomic,strong) UIButton *comButton2;

@property (nonatomic,strong) NSLayoutConstraint *topBtnConstraints;

@end
