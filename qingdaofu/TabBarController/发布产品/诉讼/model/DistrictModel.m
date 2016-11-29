//
//  DistrictModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DistrictModel.h"

@implementation DistrictModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"provinceID",
             @"idString" : @"cityID",
             @"idString" : @"areaID",
             @"name" : @"province",
             @"name" : @"city",
             @"name" : @"area"
             };
}

@end
