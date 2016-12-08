//
//  ApplyRecordModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordModel.h"

@implementation ApplyRecordModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"mobile" : @"createuser.mobile",
             @"realname" : @"createuser.realname",
             @"username" : @"createuser.username",
             @"idString" : @"createuser.id"
             };
}

@end
