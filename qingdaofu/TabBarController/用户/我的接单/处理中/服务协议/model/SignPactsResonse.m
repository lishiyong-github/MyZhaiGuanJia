//
//  SignPactsResonse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SignPactsResonse.h"

@implementation SignPactsResonse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"OrdersStatus" : @"result.data.OrdersStatus",
             @"accessOrdersORDERCOMFIRM" : @"result.data.accessOrdersORDERCOMFIRM",
             @"pacts" : @"result.data.pacts"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"pacts" : @"ImageModel"};
}

@end
