//
//  DealingCloseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "ProductOrdersClosedOrEndApplyModel.h"
#import "OrderModel.h"
#import "RowsModel.h"

@interface DealingCloseViewController : NetworkViewController

@property (nonatomic,strong) NSString *closedid;

//开始申请结案的model
@property (nonatomic,strong) OrderModel *orderModell;

@end
