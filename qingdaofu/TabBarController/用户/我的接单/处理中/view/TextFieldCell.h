//
//  TextFieldCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"
@interface TextFieldCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,strong) PlaceHolderTextView *textField;
@property (nonatomic,strong) UIButton *textDeailButton;
@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,assign) NSInteger charCount;
@property (nonatomic,strong) void (^didEndEditing)(NSString *text);
@property (nonatomic,copy) void (^touchBeginPoint)(CGPoint);

@property (nonatomic,strong) NSLayoutConstraint *topTextViewConstraints;

@end
