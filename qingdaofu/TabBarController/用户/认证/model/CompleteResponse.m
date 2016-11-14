//
//  CompleteResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompleteResponse.h"

@implementation CompleteResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"certification" : @"result.data.certification"};
}

@end
