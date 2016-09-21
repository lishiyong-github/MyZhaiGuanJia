//
//  CertificationModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CertificationModel.h"

@implementation CertificationModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"uidInner" : @"uid",
             @"idString" : @"id"
             };
}

@end
