//
//  OperatorResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class OrdersModel;

@interface OperatorResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *operators;  //经办人
@property (nonatomic,strong) OrdersModel *orders;  //

@end
