//
//  PropertyListModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PropertyListModel.h"

@implementation PropertyListModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id",
             @"attr" : @"result.attr",
             @"type" : @"result.type",
             @"uidString" : @"uid"
             };
}

@end
