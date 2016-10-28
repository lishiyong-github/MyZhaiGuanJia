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
@class ProductOrdersClosedOrEndApplyModel; //申请结案终止，处理结案终止

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

//发布人信息creater
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *idString;

@property (nonatomic,strong) RowsModel *product;//产品实际状态
@property (nonatomic,strong) OrdersModel *orders;  //申请成功后接单详情

//////////消息及权限
@property (nonatomic,copy) NSString *accessClosedAPPLY;// 当前用户对申请结案的权限
@property (nonatomic,copy) NSString *accessClosedAUTH;// 当前用户对审核结案的权限
@property (nonatomic,copy) NSString *accessClosedREAD;//当前用户对查看结案详情的权限
@property (nonatomic,copy) NSString *accessOrdersADDCOMMENT;//当前用户对添加评论的权限
@property (nonatomic,copy) NSString *accessOrdersADDOPERATOR;//当前用户对设置经办人的权限
@property (nonatomic,copy) NSString *accessOrdersADDPROCESS;//当前用户对添加进度的权限
@property (nonatomic,copy) NSString *accessOrdersORDERCOMFIRM; //当前用户对确认居间协议的权限
@property (nonatomic,copy) NSString *accessOrdersREAD; //当前用户对接单的阅读权限
@property (nonatomic,copy) NSString *accessTerminationAPPLY;//当前用户对申请终止的权限
@property (nonatomic,copy) NSString *accessTerminationAUTH; //当前用户对审核中止的权限
@property (nonatomic,copy) NSString *accessTerminationREAD;//当前用户对查看终止的权限
@property (nonatomic,copy) NSString *checkStatus;//当前接单所处状态  满足相关的所处状态和权限可执行
@property (nonatomic,copy) NSString *myCommentTotal;
@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *productOrdersClosedsApply;//当前申请中的结案
@property (nonatomic,copy) NSString *productOrdersClosedsApplyCount;  //申请结案数量
@property (nonatomic,copy) NSString *productOrdersCommentsNum;
@property (nonatomic,copy) NSString *productOrdersOperatorsCount;////经办人数量
@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *productOrdersTerminationsApply;//当前申请中的终止

@property (nonatomic,copy) NSString *productOrdersTerminationsApplyCount; //申请/终止数量

@end
