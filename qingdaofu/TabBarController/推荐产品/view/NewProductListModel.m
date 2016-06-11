//
//  NewProductListModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NewProductListModel.h"

@implementation NewProductListModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"codeString" : @"code",
             @"idString" : @"id",
             @"uidString" : @"uid"};
}

@end
