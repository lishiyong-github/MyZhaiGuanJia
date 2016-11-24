//
//  ProductDetailModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApplyRecordModel;
@class CompleteResponse;
@class  CertificationModel;

@interface ProductDetailModel : NSObject

@property (nonatomic,strong) ApplyRecordModel *apply;  //申请人信息
@property (nonatomic,strong) CompleteResponse *User;  //发布方认证信息
@property (nonatomic,strong) CertificationModel *certification;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *applyPeople;
@property (nonatomic,copy) NSString *productid;
@property (nonatomic,copy) NSString *browsenumber;
@property (nonatomic,copy) NSString *applyTotal;
@property (nonatomic,copy) NSString *collectionTotal;
@property (nonatomic,copy) NSString *create_by;
@property (nonatomic,copy) NSString *collectionPeople;

//显示信息
@property (nonatomic,copy) NSString *number; //code
@property (nonatomic,copy) NSString *statusLabel; //发布中
@property (nonatomic,copy) NSString *accountLabel;//0万(委托金额)
@property (nonatomic,copy) NSString *typenumLabel; //委托费用值
@property (nonatomic,copy) NSString *typeLabel; //委托费用单位
@property (nonatomic,copy) NSString *categoryLabel;//合同纠纷.机动车抵押(债权类型)
@property (nonatomic,copy) NSString *entrustLabel; //诉讼,债权转让(委托事项)
@property (nonatomic,copy) NSString *addressLabel; //上海市杨浦区(合同履行地)
@property (nonatomic,copy) NSString *overdue;  //违约期限
@property (nonatomic,copy) NSString *applyStatus;

@end
