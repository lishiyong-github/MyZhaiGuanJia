//
//  NSDate+FormatterTime.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/8.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FormatterTime)

+ (NSString *)getFormatterTime:(NSString *)timeInterval;

+ (NSString *)getYMDhmsFormatterTime:(NSString *)timeInterval;

+ (NSString *)getYMDFormatterTime:(NSString *)timeInterval;

+ (NSString *)getMDhmFormatterTime:(NSString *)timeInterval;

+ (NSString *)getYMDhmFormatterTime:(NSString *)timeInterval;


+ (NSString *)getOtherYMDhmsFormatterTime:(NSString *)timeInterval;

+ (NSString *)getYMDsFormatterTime:(NSString *)timeInterval;
+ (NSString *)getHMFormatterTime:(NSString *)timeInterval;


@end
