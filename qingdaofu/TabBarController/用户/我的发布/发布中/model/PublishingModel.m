//
//  PublishingModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PublishingModel.h"

@implementation PublishingModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"codeString" : @"code",
             @"idString" : @"id",
             @"uidInner" : @"uid"};
}

@end
