//
//  CaseNoCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseNoCell : UITableViewCell

@property (nonatomic,strong) UIButton *caseNoButton;
@property (nonatomic,strong) UITextField *caseNoTextField;
@property (nonatomic,strong) UIButton *caseGoButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
