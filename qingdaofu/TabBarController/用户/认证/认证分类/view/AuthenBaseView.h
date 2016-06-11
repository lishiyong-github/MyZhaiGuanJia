//
//  AuthenBaseView.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenBaseView : UIView

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) NSLayoutConstraint *leftTextConstraints;

@end
