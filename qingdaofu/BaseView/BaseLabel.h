//
//  BaseLabel.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLabel : UIView

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *tagImageView;
@property (nonatomic,strong) UIButton *goButton;

@property (nonatomic,assign) CGFloat aH;

@end
