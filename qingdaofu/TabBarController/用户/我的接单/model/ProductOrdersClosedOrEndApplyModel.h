//
//  ProductOrdersClosedOrEndApplyModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductOrdersClosedOrEndApplyModel : NSObject

@property (nonatomic,copy) NSString *terminationid;  //终止ID
@property (nonatomic,copy) NSString *productid; //产品ID
@property (nonatomic,copy) NSString *ordersid;//接单ID
@property (nonatomic,copy) NSString *applymemo; //终止申请原因备注,//结案申请原因备注
@property (nonatomic,copy) NSString *resultmemo;//终止审核原因备注, //结案审核原因备注
@property (nonatomic,copy) NSString *files;//相关附件
@property (nonatomic,copy) NSString *status;//终止状态 （0申请终止中,10终止失败，20终止成功） //结案状态（0申请结案中,10结案失败，20结案成功）
@property (nonatomic,copy) NSString *create_at;//申请时间
@property (nonatomic,copy) NSString *create_by;//申请人
@property (nonatomic,copy) NSString *modify_at;//审核时间
@property (nonatomic,copy) NSString *modify_by;//审核人


@property (nonatomic,copy) NSString *closedid;  //结案ID
@property (nonatomic,copy) NSString *price;// 结案金额
@property (nonatomic,copy) NSString *price2;//实收佣金
@property (nonatomic,copy) NSString *priceLabel;// 结案金额显示
@property (nonatomic,copy) NSString *price2Label;//实收佣金显示

@property (nonatomic,strong) NSMutableArray *filesImg; //图片

@property (nonatomic,copy) NSString *number; //合同编号
@property (nonatomic,copy) NSString *accountLabel; //委托金额
@property (nonatomic,copy) NSString *typeLabel;//委托费用单位
@property (nonatomic,copy) NSString *typenumLabel;//委托费用金额

@end
