//
//  ProgressCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *ppLine1; //分割线1
@property (nonatomic,strong) UILabel *ppLabel;//时间
@property (nonatomic,strong) UIButton *ppTypeButton;  //图片类型
@property (nonatomic,strong) UIButton *ppTextButton;
@property (nonatomic,strong) UILabel *ppLine2; //分割线2

@property (nonatomic,strong) NSLayoutConstraint *leftTextConstraints;

@end
