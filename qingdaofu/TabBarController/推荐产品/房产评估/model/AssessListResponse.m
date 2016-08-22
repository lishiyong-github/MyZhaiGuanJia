//
//  AssessListResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/22.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AssessListResponse.h"

@implementation AssessListResponse

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data"};
}

 + (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"AssessModel"};
}
@end
