//
//  OrderModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"createuser.id",
             @"mobile" : @"createuser.mobile",
             @"picture" : @"createuser.picture",
             @"pid" : @"createuser.pid",
             @"realname" : @"createuser.realname",
             @"username" : @"createuser.username"
             };
}

@end
