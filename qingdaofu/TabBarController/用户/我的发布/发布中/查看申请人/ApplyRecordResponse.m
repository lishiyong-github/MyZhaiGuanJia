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
    return @{@"data" : @"ApplyRecordModel"};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

@end
