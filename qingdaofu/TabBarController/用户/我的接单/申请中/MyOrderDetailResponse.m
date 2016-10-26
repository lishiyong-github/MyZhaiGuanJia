//
//  MyOrderDetailResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyOrderDetailResponse.h"

@implementation MyOrderDetailResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

@end
