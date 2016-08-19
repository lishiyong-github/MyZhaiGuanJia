//
//  ImageModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"fileid" : @"result.fileid",
             @"name" : @"result.name",
             @"size" : @"result.size",
             @"type" : @"result.type",
             @"url" : @"result.url"
             };
}

@end
