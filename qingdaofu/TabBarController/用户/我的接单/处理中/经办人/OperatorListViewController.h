//
//  OperatorListViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface OperatorListViewController : NetworkViewController

@property (nonatomic,strong) NSString *ordersid;

@property (nonatomic,strong) NSString *isAdd; //1-可以新增，2-只可查看

@end
