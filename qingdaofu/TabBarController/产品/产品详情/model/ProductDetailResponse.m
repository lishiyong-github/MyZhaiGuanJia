//
//  ProductDetailResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductDetailResponse.h"

@implementation ProductDetailResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

@end
