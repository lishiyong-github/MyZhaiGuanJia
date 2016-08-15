//
//  AssessCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssessCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UITextField *textField1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UITextField *textField2;
@property (nonatomic,strong) UILabel *label3;

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) void (^didEndEditing)(NSString *);

@end
