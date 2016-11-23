//
//  ProductOrdersClosedOrEndApplyModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductOrdersClosedOrEndApplyModel.h"

@implementation ProductOrdersClosedOrEndApplyModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"filesImg" : @"ImageModel",
             @"accountLabel" : @"product.accountLabel",
             @"number" : @"product.number",
             @"typenumLabel" : @"product.typenumLabel",
             @"typeLabel" : @"product.typeLabel"};
}

@end
