//
//  LoginView.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenModel.h"
@interface LoginView : UIView

@property (nonatomic,strong) void (^didSelectedIndex)(NSIndexPath*);
@property (nonatomic,strong) void (^didSelectedButton)(NSInteger);

@property (nonatomic,strong) TokenModel *model;
@property (nonatomic,strong) UITableView *loginTableView;

@end
