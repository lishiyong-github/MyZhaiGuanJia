//
//  OrderResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OrderResponse.h"

@implementation OrderResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"OrderModel"};
}

@end
