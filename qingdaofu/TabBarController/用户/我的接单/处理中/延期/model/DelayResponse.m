//
//  DelayResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DelayResponse.h"

@implementation DelayResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"delay" : @"result.delay"
             };
}

@end
