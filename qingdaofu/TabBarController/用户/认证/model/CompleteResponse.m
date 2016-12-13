//
//  CompleteResponse.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "CompleteResponse.h"

@implementation CompleteResponse

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"certification" : @"result.data.certification",
             @"commentdata" : @"result.data.commentdata",
             @"canContacts" : @"result.data.canContacts",
             @"idString" : @"result.data.id",
             @"isSetPassword" : @"result.data.isSetPassword",
             @"mobile" : @"result.data.mobile",
             @"operatorDo" : @"result.data.operatorDo",
             @"pictureimg" : @"result.data.pictureimg",
             @"pictureurl" : @"result.data.pictureurl",
             @"realname" : @"result.data.realname",
             @"username" : @"result.data.username"};
}

@end
