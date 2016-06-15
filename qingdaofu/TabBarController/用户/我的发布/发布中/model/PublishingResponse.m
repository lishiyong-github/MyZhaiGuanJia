//
//  PublishingResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PublishingResponse.h"

@implementation PublishingResponse
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"creditor" : @"result.creditor",
            @"product" : @"result.product",
             @"uidString" : @"result.uid",
             @"borrowinginfos" : @"result.borrowinginfos",
             @"creditorfiles" : @"result.creditorfiles",
             @"creditorinfos" : @"result.creditorinfos",
             @"guaranteemethods" : @"result.guaranteemethods",
             @"user" : @"result.user"
           };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"uidString" : @"uid",
             @"user" : @"UserModel"
             };
}

@end
