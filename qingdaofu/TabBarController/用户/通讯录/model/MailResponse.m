//
//  MailResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MailResponse.h"

@implementation MailResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"MailResponseModel"};
}

@end
