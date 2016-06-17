//
//  TokenModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "TokenModel.h"

@implementation TokenModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"category" : @"result.category",
             @"uidString" : @"result.uidString",
             @"pid" : @"result.pid",
             @"mobile" : @"result.mobile",
             @"state" : @"result.state",
             @"idString" : @"result.idString"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"uidString" : @"uid",
             @"idString" : @"id"
             };
}

@end
