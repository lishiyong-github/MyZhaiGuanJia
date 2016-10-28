//
//  MyOrderDetailResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderModel;

@interface MyOrderDetailResponse : BaseModel

@property (nonatomic,strong) OrderModel *data;

@end
