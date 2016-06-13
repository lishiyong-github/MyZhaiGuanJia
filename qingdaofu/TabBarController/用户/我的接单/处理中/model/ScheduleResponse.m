//
//  ScheduleResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ScheduleResponse.h"

@implementation ScheduleResponse


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"disposing" : @"result.disposing",
             @"uid" : @"result.uid"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"disposing" : @"ScheduleModel"};
}

@end
