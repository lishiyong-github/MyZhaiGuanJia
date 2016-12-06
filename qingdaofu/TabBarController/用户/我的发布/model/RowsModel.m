//
//  RowsModel.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RowsModel.h"

@implementation RowsModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"applystatussss" : @"apply.status"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"SignPicture" : @"ImageModel"};
}

//+ (NSDictionary *)objectClassInArray
//{
//    return @{@"productMortgages1" : @"MoreMessageModel",//抵押物地址
//             @"productMortgages2" : @"MoreMessageModel",//机动车抵押
//             @"productMortgages3" : @"MoreMessageModel"//合同纠纷
//             };
//}

@end
