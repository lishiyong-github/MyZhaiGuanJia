//
//  PayResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PayResponse.h"

@implementation PayResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"paydata" : @"result.paydata"};
}

@end
