//
//  DealEndDeatiResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DealEndDeatiResponse.h"

@implementation DealEndDeatiResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data",
             @"accessTerminationAUTH" : @"result.accessTerminationAUTH",
             @"dataLabel" : @"result.dataLabel"
             };
}

@end
