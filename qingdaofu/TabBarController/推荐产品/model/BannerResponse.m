//
//  BannerResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/12/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BannerResponse.h"

@implementation BannerResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"banner" : @"result.banner"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"banner" : @"ImageModel"};
}

@end
