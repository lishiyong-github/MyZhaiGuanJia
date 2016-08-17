//
//  CourtProvinceResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CourtProvinceResponse.h"

@implementation CourtProvinceResponse

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"CourtProvinceModel"};
}

@end
