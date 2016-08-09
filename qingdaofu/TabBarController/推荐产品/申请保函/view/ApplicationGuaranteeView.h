//
//  ApplicationGuaranteeView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationGuaranteeView : UIView

@property (nonatomic,strong) UIButton *firstButton;
@property (nonatomic,strong) UIButton *secondButton;
@property (nonatomic,strong) UIButton *thirdButton;
@property (nonatomic,strong) UILabel *blueLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSLayoutConstraint *leftBlueConstraints;

@end
