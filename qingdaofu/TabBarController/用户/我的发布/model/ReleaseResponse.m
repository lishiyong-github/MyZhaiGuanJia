//
//  ReleaseResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseResponse.h"

@implementation ReleaseResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data",
             @"sum" : @"result.sum"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"RowsModel"};
}

@end
