//
//  ReceiptResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiptResponse.h"

@implementation ReceiptResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}


+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"ReceiptModel"};
}

@end
