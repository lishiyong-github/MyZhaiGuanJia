//
//  ReleaseResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseResponse.h"

@implementation ReleaseResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"creditor" : @"result.creditor",
             @"mobile" : @"result.mobile",
             @"delays" : @"result.delays",
             @"page" : @"result.page",
             @"rows" : @"result.rows"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"rows" : @"RowsModel"
             };
}

@end
