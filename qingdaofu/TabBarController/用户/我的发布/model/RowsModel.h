//
//  RowsModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RowsModel : NSObject

@property (nonatomic,copy) NSString *codeString;  //产品编号
@property (nonatomic,copy) NSString *category;   //类型：1为融资。2为清收。3为诉讼。
@property (nonatomic,copy) NSString *idString;    //对应产品表的ID
@property (nonatomic,copy) NSString *product_id;  //申请状态表对应产品表的ID
@property (nonatomic,copy) NSString *progress_status;   //进展状态：0为待发布（保存未发布的）。 1为发布中（已发布的）。2为处理中（有人已接单发布方也已同意）。3为终止（只用发布方可以终止）。4为结案（双方都可以申请，一方申请一方同意）

@property (nonatomic,copy) NSString *app_id;  //接单方申请的状态：0为申请中（接单方刚发起申请）。1为申请成功（发布方已同意接单方的申请）。2为收藏（接单方将数据收藏但为申请）。
@property (nonatomic,copy) NSString *applyclose;  //状态：3为终止。4为结案
@property (nonatomic,copy) NSString *applyclosefrom;   //发起申请人的uid
@property (nonatomic,copy) NSString *pid;   //申请人的uid
@property (nonatomic,copy) NSString *uidString;  //申请人的uid
@property (nonatomic,copy) NSString *applyid;  //删除ID
@property (nonatomic,copy) NSString *applymobile;//联系接单方，联系发布方
@property (nonatomic,copy) NSString *is_del; //产品是否删除 0-未删除，1-已删除

@property (nonatomic,copy) NSString *create_time;  //
@property (nonatomic,copy) NSString *modify_time;  //收藏时间
@property (nonatomic,copy) NSString *province_id;  //省份ID
@property (nonatomic,copy) NSString *city_id;   //城市ID
@property (nonatomic,copy) NSString *district_id;  //区域ID

@property (nonatomic,copy) NSString *money;     //产品金额
@property (nonatomic,copy) NSString *agencycommission;   //代理费用
@property (nonatomic,copy) NSString *agencycommissiontype; //代理费用类型：1为固定费用(万)  2为风险费率(%)
@property (nonatomic,copy) NSString *loan_type;    //债权类型：1为房产抵押。2为应收账款。3为机动车抵押。4为无抵押
@property (nonatomic,copy) NSString *mortgagecategory; //抵押物类型
@property (nonatomic,copy) NSString *seatmortgage;  //抵押物所在地（省市区）
@property (nonatomic,copy) NSString *mortorage_community;  //小区名（详细地址）
@property (nonatomic,copy) NSString *accountr;  //应收帐款
@property (nonatomic,copy) NSString *audi; //车信息
@property (nonatomic,copy) NSString *carbrand;//车信息
@property (nonatomic,copy) NSString *licenseplate;//车信息

@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *rate;   //利率
@property (nonatomic,copy) NSString *rate_cat;  //利率类型：1为天。2为月
@property (nonatomic,copy) NSString *rebate;   //返点
@property (nonatomic,copy) NSString *term;  //借款期限
@property (nonatomic,copy) NSString *status;  //房子状态   1=>'自住',2=>'出租',
@property (nonatomic,copy) NSString *rentmoney;  //租金
@property (nonatomic,copy) NSString *mortgagearea;  //抵押物面积
@property (nonatomic,copy) NSString *loanyear;  //借款人年龄
@property (nonatomic,copy) NSString *obligeeyear; //权利人年龄


@end
