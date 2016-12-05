//
//  OperatorResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OperatorResponse.h"

@implementation OperatorResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"operators" : @"result.data.operators",
             @"orders" : @"result.data.orders",
             @"accessOrdersADDOPERATOR" : @"result.data.accessOrdersADDOPERATOR"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"operators" : @"OperatorModel"};
}

@end
