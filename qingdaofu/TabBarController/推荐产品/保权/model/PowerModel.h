//
//  PowerModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerModel : NSObject

@property (nonatomic,copy) NSString *account;  //保全金额
@property (nonatomic,copy) NSString *address;  //快递地址
@property (nonatomic,copy) NSString *create_time;//申请时间
@property (nonatomic,copy) NSString *fayuan_address;//自取地址
@property (nonatomic,copy) NSString *fayuan_name;  //法院名字
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *number;  //保全单号
@property (nonatomic,copy) NSString *status;  //保全状态 1-审核未通过
@property (nonatomic,copy) NSString *type; //取函方式
@end
