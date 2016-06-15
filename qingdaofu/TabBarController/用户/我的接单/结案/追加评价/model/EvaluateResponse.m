//
//  EvaluateResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateResponse.h"

@implementation EvaluateResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"creditor" : @"result.creditor",
             @"creditors" : @"result.creditors",
             @"evalua" : @"result.evalua",
             @"evaluate" : @"result.evaluate",
             @"launchevaluation" : @"result.launchevaluation",
             @"uid" : @"result.uid"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"evaluate" : @"EvaluateModel",
             @"launchevaluation" : @"LaunchEvaluateModel"
             };
}

@end
