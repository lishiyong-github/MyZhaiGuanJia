//
//  ApplicationDetailResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationDetailResponse.h"

@implementation ApplicationDetailResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"model" : @"result.model"};
}

@end
