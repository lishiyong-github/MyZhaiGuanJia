//
//  LoginCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface LoginCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *loginTextField;
@property (nonatomic,strong) JKCountDownButton *getCodebutton;
@property (nonatomic,strong) UISwitch *loginSwitch;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSLayoutConstraint *topConstraint;

@property (nonatomic,strong) void (^finishEditing)(NSString *);
@property (nonatomic,strong) void (^didEndSwitching)(BOOL);


@end
