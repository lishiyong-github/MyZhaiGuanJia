//
//  PropertyListResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PropertyListResponse.h"

@implementation PropertyListResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"PropertyListModel"};
}

@end
