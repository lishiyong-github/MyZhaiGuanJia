//
//  ApplyRecordResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordResponse.h"

@implementation ApplyRecordResponse

+ (NSDictionary *)objectClassInArray
{
    return @{@"apply" : @"ApplyRecordModel"};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"apply" : @"result.data.apply"};
}

@end
