//
//  PublishingResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PublishingResponse.h"
@class DebtModel;

@implementation PublishingResponse
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"creditor" : @"result.creditor",
            @"product" : @"result.product",
             @"uidString" : @"uid",
             @"car" : @"result.car",
             @"license" : @"result.license",
             @"borrowinginfo" : @"result.borrowinginfo",
             @"creditorfile" : @"result.creditorfile",
             @"creditorinfo" : @"result.creditorinfo",
             @"guaranteemethods" : @"result.guaranteemethods",
             @"user" : @"result.user",
             @"state" : @"result.state",
             @"province_id" : @"result.province_id",
             @"city_id" : @"result.city_id",
             @"district_id" : @"result.district_id",
             @"place_province_id" : @"result.place_province_id",
             @"place_city_id" : @"result.place_city_id",
             @"place_district_id" : @"result.place_district_id",
             @"data" : @"result.data"
           };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"uidString" : @"uid",
             @"borrowinginfos" : @"DebtModel",
             @"creditorinfos" : @"DebtModel"
             };
}

@end
