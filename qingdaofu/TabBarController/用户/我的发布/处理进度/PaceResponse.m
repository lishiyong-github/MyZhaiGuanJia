//
//  PaceResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceResponse.h"

@implementation PaceResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}


+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"OrdersLogsModel"};
}


@end
