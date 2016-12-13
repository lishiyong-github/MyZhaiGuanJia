//
//  CompetetesResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/12/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompetetesResponse.h"

@implementation CompetetesResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"certification" : @"result.certification"};
}

@end
