//
//  ReceiptModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiptModel.h"

@implementation ReceiptModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id",
             @"uidInner" : @"uid"
             };
}

@end
