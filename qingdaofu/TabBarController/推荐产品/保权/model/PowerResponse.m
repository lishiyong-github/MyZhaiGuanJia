//
//  PowerResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerResponse.h"

@implementation PowerResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"PowerModel"};
}

@end
