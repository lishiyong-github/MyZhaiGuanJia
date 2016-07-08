//
//  NSString+ValidString.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NSString+ValidString.h"

@implementation NSString (ValidString)

+ (NSString *)getValidStringFromString:(NSString *)string
{
    if ([string isEqualToString:@""] || !string || [string isEqualToString:@"(null)"]) {
        string = @"暂无";
    }
    return string;
}

+ (NSString *)getValidStringFromString:(NSString *)string toString:(NSString *)toString
{
    if ([string isEqualToString:@""] || !string || [string isEqualToString:@"(null)"]) {
        string = toString;
    }
    return string;
}

@end
