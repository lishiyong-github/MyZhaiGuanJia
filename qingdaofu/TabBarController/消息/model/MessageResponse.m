//
//  MessageResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MessageResponse.h"

@implementation MessageResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"data" : @"result.data",
             @"systemCount" : @"result.systemCount",
             @"totalCount" : @"result.totalCount",
             @"curCount" : @"result.curCount",
             @"pageSize" : @"result.pageSize",
             @"curpage" : @"result.curpage"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"data" : @"MessagesModel"};
}

@end
