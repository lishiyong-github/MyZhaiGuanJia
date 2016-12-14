//
//  OperatorResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class OrderModel;

@interface OperatorResponse : BaseModel

@property (nonatomic,assign) BOOL accessOrdersADDOPERATOR;  //添加经办人权限
@property (nonatomic,strong) NSMutableArray *operators;  //经办人
@property (nonatomic,strong) OrderModel *orders;  //接单方

@end
