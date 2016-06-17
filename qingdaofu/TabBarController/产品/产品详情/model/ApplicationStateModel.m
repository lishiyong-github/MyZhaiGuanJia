//
//  ApplicationStateModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationStateModel.h"

@implementation ApplicationStateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"agree_time" : @"result.agree_time",
             @"app_id" : @"result.app_id",
             @"create_time" : @"result.create_time",
             @"is_del" : @"result.is_del"
             };
}

@end
