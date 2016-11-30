//
//  MainProductview.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainProductview : UIButton

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIImageView *userImageView;//用户头像
@property (nonatomic,strong) UIButton *storeButton;//收藏按钮
@property (nonatomic,strong) UILabel *categoryLabel1;
@property (nonatomic,strong) UILabel *categoryLabel2;
@property (nonatomic,strong) UILabel *categoryLabel3;
@property (nonatomic,strong) UILabel *categoryLabel4;
@property (nonatomic,strong) UIButton *leftButton; //委托费用
@property (nonatomic,strong) UIButton *rightButton; //委托金额
@property (nonatomic,strong) UIButton *applyButton;  //立即申请按钮

@end
