//
//  NewProductResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewProductResponse.h"

@implementation NewProductResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"appCount" : @"result.appCount",
             @"certification" : @"result.certification",
             @"data" : @"result.data",
             @"number" : @"result.number"
             };
}

@end
