//
//  DistrictResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DistrictResponse.h"

@implementation DistrictResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"CityModel"};
}

@end
