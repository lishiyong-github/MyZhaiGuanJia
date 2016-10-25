//
//  MailResponseModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MailResponseModel.h"

@implementation MailResponseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"mobile" : @"userinfo.mobile",
             @"realname" : @"userinfo.realname",
             @"username" : @"userinfo.username"
             };
}

@end
