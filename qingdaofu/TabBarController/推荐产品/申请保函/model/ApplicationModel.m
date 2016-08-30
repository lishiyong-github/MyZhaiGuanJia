//
//  ApplicationModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationModel.h"
//@class ImageModel;

@implementation ApplicationModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idString" : @"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"qisu" : @"ImageModel",
             @"caichan" : @"ImageModel",
             @"zhengju" : @"ImageModel",
             @"anjian" : @"ImageModel"
             };
}

@end
