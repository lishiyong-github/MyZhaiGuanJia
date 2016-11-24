//
//  MailModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MailModel.h"

@implementation MailModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"mobile" : @"result.userData.mobile",
             @"ID" : @"result.userData.id",
             @"username" : @"result.userData.username",
             @"realname" : @"result.userData.realname"
             };
}

@end
