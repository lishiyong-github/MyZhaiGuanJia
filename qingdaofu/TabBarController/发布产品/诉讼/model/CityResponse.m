//
//  CityResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CityResponse.h"

@implementation CityResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"CityModel"};
}

@end
