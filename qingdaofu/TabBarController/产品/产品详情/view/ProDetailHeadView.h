//
//  ProDetailHeadView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LineLabel.h"
#import "ProDetailHeadFootView.h"

@interface ProDetailHeadView : UIView

@property (nonatomic,strong) UILabel *deRateLabel;
@property (nonatomic,strong) UILabel *deRateLabel1;

@property (nonatomic,strong) ProDetailHeadFootView *deMoneyView;
@property (nonatomic,strong) ProDetailHeadFootView *deTypeView;

@property (nonatomic,strong) LineLabel *deLineLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
