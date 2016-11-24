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
    return @{@"Comments1" : @"result.data.Comments1",
             @"commentsScore" : @"result.data.commentsScore"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"Comments1" : @"EvaluateModel"};
}

@end
