//
//  OrderModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RowsModel;
@class OrdersModel;

@interface OrderModel : NSObject

//我接单的状态
@property (nonatomic,copy) NSString *applyid;
@property (nonatomic,copy) NSString *create_at;
@property (nonatomic,copy) NSString *create_by;
@property (nonatomic,copy) NSString *modify_at;
@property (nonatomic,copy) NSString *modify_by;
@property (nonatomic,copy) NSString *productid;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *statusLabel;
@property (nonatomic,copy) NSString *validflag;

//发布人信息
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *idString;

@property (nonatomic,strong) RowsModel *product;//产品实际状态
@property (nonatomic,strong) OrdersModel *orders;  //申请成功后接单详情

@end
