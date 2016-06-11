//
//  ModifyView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyView : UIView

@property (nonatomic,strong) UITextField *leftTextField;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
