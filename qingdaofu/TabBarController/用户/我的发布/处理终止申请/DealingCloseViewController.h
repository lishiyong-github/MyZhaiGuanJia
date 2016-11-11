//
//  DealingCloseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "ProductOrdersClosedOrEndApplyModel.h"

@interface DealingCloseViewController : NetworkViewController

@property (nonatomic,strong) NSString *perTypeString;  //1-发布方（同意结案功能），2-接单方（查看功能）
@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *productDealModel;

@end
