//
//  RowsModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CourtProvinceModel;
@class PublishingModel;  //发布方信息
@class ApplyRecordModel;//接单方信息
@class CompleteResponse; //发布方认证信息
@class ProductOrdersClosedOrEndApplyModel;  //处理结案或终止
@class ProductDetailModel;
@class OrdersModel;

@interface RowsModel : NSObject

/////////
@property (nonatomic,copy) NSString *apply;
@property (nonatomic,copy) NSString *applystatussss;//产品列表判断申请状态
@property (nonatomic,copy) NSString *commentTotal;  //评论次数

//首页产品列表
@property (nonatomic,strong) ApplyRecordModel *collectSelf;  //收藏与否
@property (nonatomic,strong) ApplyRecordModel *applySelf;  //申请与否

//我的发布列表
@property (nonatomic,strong) ApplyRecordModel *curapply;  //当前申请人信息
@property (nonatomic,strong) OrdersModel *orders;  //接单人


@property (nonatomic,copy) NSString *applyCount;  //申请次数（产品详情用）
@property (nonatomic,copy) NSString *productid;  //产品号
@property (nonatomic,copy) NSString *number;  //BX201609280001
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *category_other;
@property (nonatomic,copy) NSString *entrust;
@property (nonatomic,copy) NSString *entrust_other;
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *type; //1-固定费用，2-风险费率
@property (nonatomic,copy) NSString *typenum;//债券费用值
@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *district_id;
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *validflag;
@property (nonatomic,copy) NSString *create_at;
@property (nonatomic,copy) NSString *create_by;
@property (nonatomic,copy) NSString *modify_at;
@property (nonatomic,copy) NSString *modify_by;
@property (nonatomic,copy) NSString *cityname;
@property (nonatomic,copy) NSString *provincename;
@property (nonatomic,copy) NSString *areaname;

//收藏信息
@property (nonatomic,copy) NSString *collectid;
@property (nonatomic,strong) ProductDetailModel *product;


//产品详情
@property (nonatomic,copy) NSString *collectionPeople;//收藏次数
@property (nonatomic,copy) NSString *collectionTotal;//收藏次数
@property (nonatomic,copy) NSString *browsenumber;//浏览次数
@property (nonatomic,copy) NSString *applyPeople;  //申请人数
@property (nonatomic,copy) NSString *applyTotal;//申请人数

@property (nonatomic,strong) PublishingModel *fabuuser;  //发布方信息
@property (nonatomic,strong) ApplyRecordModel *productApply;  //申请人信息(接单详情使用)
@property (nonatomic,strong) CompleteResponse *User;  //发布方认证信息
@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *productOrdersClosedsApply;  //当前申请中的结案
@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *productOrdersTerminationsApply;  //当前申请中的终止
@property (nonatomic,strong) ProductOrdersClosedOrEndApplyModel *productOrdersClosed;//已结案时返回的model

//显示信息
@property (nonatomic,copy) NSString *statusLabel; //发布中
@property (nonatomic,copy) NSString *accountLabel;//0万(委托金额)
@property (nonatomic,copy) NSString *typenumLabel; //委托费用值
@property (nonatomic,copy) NSString *typeLabel; //委托费用单位
@property (nonatomic,copy) NSString *categoryLabel;//合同纠纷.机动车抵押(债权类型)
@property (nonatomic,copy) NSString *entrustLabel; //诉讼,债权转让(委托事项)
@property (nonatomic,copy) NSString *addressLabel; //上海市杨浦区(合同履行地)
@property (nonatomic,copy) NSString *overdue;  //违约期限
@property (nonatomic,copy) NSString *applyStatus;
@property (nonatomic,strong) NSMutableArray *SignPicture;  //签约协议图片


@property (nonatomic,strong) NSMutableArray *productMortgages1;  //抵押物地址
@property (nonatomic,strong) NSMutableArray *productMortgages2;//机动车抵押
@property (nonatomic,strong) NSMutableArray *productMortgages3;//合同纠纷

@end
