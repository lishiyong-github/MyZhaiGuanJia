//
//  MessageResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageResponse.h"

@implementation MessageResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"message" : @"result.message"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"message" : @"MessageModel"};
}

@end
