//
//  PropertyGenerateModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PropertyGenerateModel.h"

@implementation PropertyGenerateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"result.id",
             @"money" : @"result.money"
             };
}

@end
