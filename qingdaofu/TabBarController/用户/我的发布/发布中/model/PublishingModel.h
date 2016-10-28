//
//  PublishingModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishingModel : NSObject

@property (nonatomic,copy) NSString *uidInner;  //发布人uid
@property (nonatomic,copy) NSString *codeString;  //产品编号
@property (nonatomic,copy) NSString *category;   //类别（清收，诉讼）
//@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *progress_status;
@property (nonatomic,copy) NSString *is_del;  //判断是否删除
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *applyclose;  //状态：3为终止。4为结案
@property (nonatomic,copy) NSString *applyclosefrom;  //发起申请人的uid
@property (nonatomic,copy) NSString *browsenumber; //浏览次数
@property (nonatomic,copy) NSString *modify_time;
@property (nonatomic,copy) NSString *applyid;  //删除ID

@property (nonatomic,copy) NSString *money;   //金额
@property (nonatomic,copy) NSString *agencycommission;  //代理费用
@property (nonatomic,copy) NSString *agencycommissiontype; //代理费用类型：1为固定费用(万)2为风险费率(%)
@property (nonatomic,copy) NSString *loan_type;  //债权类型  1.房产抵押；3.机动车抵押；2.应收帐款；4无抵押
@property (nonatomic,copy) NSString *mortorage_has;
@property (nonatomic,copy) NSString *mortgagecategory;  //抵押物类型
@property (nonatomic,copy) NSString *guaranteemethod;  //有无抵押物
@property (nonatomic,copy) NSString *mortorage_community;   //小区
@property (nonatomic,copy) NSString *seatmortgage;  //抵押物地址（详细地址）
@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *district_id;

@property (nonatomic,copy) NSString *accountr;  //应收帐款

@property (nonatomic,copy) NSString *audi;  //车系
@property (nonatomic,copy) NSString *carbrand;  //机动车抵押：机动车品牌
@property (nonatomic,copy) NSString *car;  //车信息
@property (nonatomic,copy) NSString *licenseplate;  //车牌类型：1=>'沪牌',2=>'非沪牌',


@property (nonatomic,copy) NSString *rate;   //利率
@property (nonatomic,copy) NSString *rate_cat;  //利率类型（月）
@property (nonatomic,copy) NSString *term;  //借款期限
@property (nonatomic,copy) NSString *repaymethod;  //还款方式1-一次性到期还本付息，2-按月付息，到期还本
@property (nonatomic,copy) NSString *obligor;  //债务人主体：1=>'自然人',2=>'法人',3=>'其他(未成年,外籍等)',
@property (nonatomic,copy) NSString *start; //逾期日期
@property (nonatomic,copy) NSString *commissionperiod;  //委托代理期限
@property (nonatomic,copy) NSString *paidmoney; //已付本金
@property (nonatomic,copy) NSString *interestpaid;   //已付利息

//合同履行地
@property (nonatomic,copy) NSString *performancecontract;  //合同履行地
@property (nonatomic,copy) NSString *place_province_id;//省市区id
@property (nonatomic,copy) NSString *place_city_id;
@property (nonatomic,copy) NSString *place_district_id;

@property (nonatomic,copy) NSString *borrowinginfo;
@property (nonatomic,copy) NSString *creditorfile;
@property (nonatomic,copy) NSString *creditorinfo;

//@property (nonatomic,copy) NSString *paymethod;  //付款方式：1=>'分期',2=>'一次性付清',
//@property (nonatomic,copy) NSString *commitment;  //委托事项：1=>'代理诉讼',2=>'代理仲裁',3=>'代理执行',
//@property (nonatomic,copy) NSString *judicialstatusA;
//@property (nonatomic,copy) NSString *judicialstatusB;
//@property (nonatomic,copy) NSString *rebate;
//@property (nonatomic,copy) NSString *status;  //状态：1=>'自住',2=>'出租',
//@property (nonatomic,copy) NSString *rentmoney; //租金
//@property (nonatomic,copy) NSString *mortgagearea;  //面积
//@property (nonatomic,copy) NSString *loanyear;  //借款人年龄
//@property (nonatomic,copy) NSString *obligeeyear;  //权利人年龄



///////////
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;

@end
