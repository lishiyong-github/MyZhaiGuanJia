//
//  PowerModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerModel.h"

@implementation PowerModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"anjian" : @"ImageModel",
             @"caichan" : @"ImageModel",
             @"qisu" : @"ImageModel",
             @"zhengju" : @"ImageModel"
             };
}

@end
