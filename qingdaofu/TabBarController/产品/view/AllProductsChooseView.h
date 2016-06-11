//
//  AllProductsChooseView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllProductsChooseView : UIView

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) void (^didSelectedButton)(UIButton *);

@property (nonatomic,strong) UIButton *squrebutton;
@property (nonatomic,strong) UIButton *stateButton;
@property (nonatomic,strong) UIButton *moneyButton;

@end
