//
//  OperatorModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OperatorModel.h"

@implementation OperatorModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"headimg" : @"userinfo.headimg",
             @"mobile" : @"userinfo.mobile",
             @"realname" : @"userinfo.realname",
             @"username" : @"userinfo.username",
             @"idString" : @"id"
             };
}

@end
