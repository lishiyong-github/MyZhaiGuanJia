//
//  MyOrderDetailCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AuthenBaseView.h"
#import "LineLabel.h"

@interface MyOrderDetailCell : UITableViewCell


@property (nonatomic,strong) AuthenBaseView *detail1;
@property (nonatomic,strong) LineLabel *lineLabel1;
@property (nonatomic,strong) UIView *detail2;
@property (nonatomic,strong) LineLabel *lineLabel2;
@property (nonatomic,strong) UIButton *detail3;

@property (nonatomic,assign) BOOL didSetupConstraits;
@property (nonatomic,assign) CGFloat aH;

@end
