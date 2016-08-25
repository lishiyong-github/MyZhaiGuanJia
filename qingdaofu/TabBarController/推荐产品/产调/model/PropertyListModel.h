//
//  PropertyListModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyListModel : NSObject

@property (nonatomic,copy) NSString *address; //详细地址
@property (nonatomic,copy) NSString *canExpress;  //0－不可快递。1－可快递
@property (nonatomic,copy) NSString *cid;  //第三方产调ID
@property (nonatomic,copy) NSString *city;  //市
@property (nonatomic,copy) NSString *expressId;  //快递单ID
@property (nonatomic,copy) NSString *expressorderId;//快递单编号
@property (nonatomic,copy) NSString *idString; //查询ID
@property (nonatomic,copy) NSString *money; //支付金额
@property (nonatomic,copy) NSString *orderId;  //订单编号
@property (nonatomic,copy) NSString *phone; //联系方式
@property (nonatomic,copy) NSString *province;//省
@property (nonatomic,copy) NSString *attr;  //查看结果提示信息
@property (nonatomic,copy) NSString *type;  //查看结果提示信息
@property (nonatomic,copy) NSString *status;//订单状态
@property (nonatomic,copy) NSString *statusLabel;  //订单状态中文描述
@property (nonatomic,copy) NSString *time; //查询时间戳
@property (nonatomic,copy) NSString *uidString; //用户ID
@property (nonatomic,copy) NSString *uptime;  //第三方产调时间戳
@property (nonatomic,copy) NSString *yongshi;  //订单使用时间

@end
