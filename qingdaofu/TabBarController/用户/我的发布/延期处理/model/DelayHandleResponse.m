//
//  DelayHandleResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "DelayHandleResponse.h"

@implementation DelayHandleResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

@end
