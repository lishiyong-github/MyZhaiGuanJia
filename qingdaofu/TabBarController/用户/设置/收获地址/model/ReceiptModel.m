//
//  ReceiptModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiptModel.h"

@implementation ReceiptModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id",
             @"uidInner" : @"uid",
             @"area_name" : @"areaname.area_name",
             @"city_name" : @"cityname.city_name",
             @"province_name" : @"provincename.province_name"
             };
}

@end
