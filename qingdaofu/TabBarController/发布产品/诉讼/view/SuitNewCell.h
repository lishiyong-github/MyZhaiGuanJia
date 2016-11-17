//
//  SuitNewCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitNewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *cateLabel;
@property (nonatomic,strong) UIButton *optionButton1;
@property (nonatomic,strong) UIButton *optionButton2;
@property (nonatomic,strong) UIButton *optionButton3;
@property (nonatomic,strong) UIButton *optionButton4;
@property (nonatomic,strong) UITextField *optionTextField;

@property (nonatomic,strong) void (^didSelectedButton)(UIButton *);
@property (nonatomic,strong) void (^didEndEditting)(NSString *);
@property (nonatomic,strong) void (^didBeginEditting)(NSString *);

@end
