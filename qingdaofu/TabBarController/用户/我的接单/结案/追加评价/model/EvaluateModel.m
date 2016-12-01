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
    return @{@"ID" : @"userinfo.id",
             @"username" : @"userinfo.username",
             @"realname" : @"userinfo.realname",
             @"mobile" : @"userinfo.mobile",
             @"picture" : @"userinfo.picture",
             @"headimg" : @"userinfo.headimg"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"filesImg" : @"ImageModel"};
}


@end
