//
//  CategoryModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id"};
}

@end
