//
//  PublishingModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishingModel : NSObject

@property (nonatomic,copy) NSString *accountr;
@property (nonatomic,copy) NSString *agencycommission;  //代理费用
@property (nonatomic,copy) NSString *agencycommissiontype;
@property (nonatomic,copy) NSString *applyclose;
@property (nonatomic,copy) NSString *applyclosefrom;
@property (nonatomic,copy) NSString *audi;
@property (nonatomic,copy) NSString *borrowinginfo;
@property (nonatomic,copy) NSString *browsenumber;
@property (nonatomic,copy) NSString *carbrand;
@property (nonatomic,copy) NSString *category;   //类别（融资，催收，诉讼）
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *codeString;
@property (nonatomic,copy) NSString *commissionperiod;  //委托代理期限
@property (nonatomic,copy) NSString *commitment;  //委托事项
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *creditorfile;
@property (nonatomic,copy) NSString *creditorinfo;
@property (nonatomic,copy) NSString *district_id;
@property (nonatomic,copy) NSString *guaranteemethod;  //有无抵押物
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *interestpaid;
@property (nonatomic,copy) NSString *is_del;
@property (nonatomic,copy) NSString *judicialstatusA;
@property (nonatomic,copy) NSString *judicialstatusB;
@property (nonatomic,copy) NSString *licenseplate;
@property (nonatomic,copy) NSString *loan_type;  //债权类型
@property (nonatomic,copy) NSString *modify_time;
@property (nonatomic,copy) NSString *money;   //金额
@property (nonatomic,copy) NSString *mortorage_community;
@property (nonatomic,copy) NSString *mortorage_has;
@property (nonatomic,copy) NSString *obligor;  //债务人主体
@property (nonatomic,copy) NSString *paidmoney;
@property (nonatomic,copy) NSString *paymethod;
@property (nonatomic,copy) NSString *performancecontract;
@property (nonatomic,copy) NSString *progress_status;
@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *rate;   //利率
@property (nonatomic,copy) NSString *rate_cat;
@property (nonatomic,copy) NSString *rebate;
@property (nonatomic,copy) NSString *repaymethod;  //还款方式
@property (nonatomic,copy) NSString *seatmortgage;  //抵押物地址
@property (nonatomic,copy) NSString *term;  //借款期限
@property (nonatomic,copy) NSString *uidInner;


@end
