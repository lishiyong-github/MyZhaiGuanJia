//
//  DialogBoxView.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogBoxView : UIView<UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITextField *dialogTextField;
@property (nonatomic,strong) UIButton *dialogButton;

@property (nonatomic,strong) void (^didEndEditting)(NSString *);

@end
