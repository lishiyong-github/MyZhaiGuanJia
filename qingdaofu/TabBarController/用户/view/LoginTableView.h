//
//  LoginTableView.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenModel.h"

@interface LoginTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) void (^didSelectedButton)(NSInteger);

@property (nonatomic,strong) TokenModel *model;

@end
