//
//  ProDetailHeadFootView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProDetailHeadFootView : UIView

@property (nonatomic,strong) UILabel *fLabel1;
@property (nonatomic,strong) UILabel *fLabel2;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSLayoutConstraint *spaceConstant; //间隔
@property (nonatomic,strong) NSLayoutConstraint *topConstant;

@end
