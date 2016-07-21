//
//  EvaluateModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateModel.h"

@implementation EvaluateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id",
             @"uidInner" : @"uid"
             };
}


@end
