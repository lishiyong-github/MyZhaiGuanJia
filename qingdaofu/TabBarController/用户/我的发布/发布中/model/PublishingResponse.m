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
             @"borrowinginfos" : @"result.borrowinginfos",
             @"creditorfiles" : @"result.creditorfiles",
             @"creditorinfos" : @"result.creditorinfos",
             @"guaranteemethods" : @"result.guaranteemethods",
             @"user" : @"result.user",
             @"state" : @"result.state"
           };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"uidString" : @"uid",
             @"user" : @"UserModel",
             @"borrowinginfos" : @"DebtModel",
             @"creditorinfos" : @"DebtModel"
             };
}

@end
