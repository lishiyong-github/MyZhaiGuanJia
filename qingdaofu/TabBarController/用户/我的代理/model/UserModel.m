//
//  UserModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id",
             @"uidInner" : @"uid"
             };
}

@end
