//
//  RowsModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RowsModel.h"

@implementation RowsModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"codeString" : @"code",
             @"idString" : @"id",
             @"uidString" : @"uid"
             };
}

@end
