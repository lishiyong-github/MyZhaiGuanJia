//
//  OrdersModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersModel : NSObject

@property (nonatomic,copy) NSString *ordersid;
@property (nonatomic,copy) NSString *productid;
@property (nonatomic,copy) NSString *applyid;
@property (nonatomic,copy) NSString *status;//接单状态（0居间协议确认，10协议上传，20处置，30终止，40结案）
@property (nonatomic,copy) NSString *pact;
@property (nonatomic,copy) NSString *create_at;
@property (nonatomic,copy) NSString *create_by;

//日志
@property (nonatomic,strong) NSMutableArray *productOrdersLogs;


@end
