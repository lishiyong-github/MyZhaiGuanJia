//
//  NewProductListModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewProductListModel : NSObject

@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *codeString;

@property (nonatomic,copy) NSString *money; //借款本金
@property (nonatomic,copy) NSString *agencycommission;  //代理费用
@property (nonatomic,copy) NSString *agencycommissiontype; //代理类型
@property (nonatomic,copy) NSString *browsenumber;  //浏览次数

@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *district_id;
@property (nonatomic,copy) NSString *location;  //具体地址

@property (nonatomic,copy) NSString *accountr; //应收帐款

@property (nonatomic,copy) NSString *carbrand; //车品牌
@property (nonatomic,copy) NSString *audi;//车系
@property (nonatomic,copy) NSString *licenseplate; //1沪牌 2非沪牌

@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *loan_type;  //债权类型
@property (nonatomic,copy) NSString *modify_time; //修改时间
@property (nonatomic,copy) NSString *progress_status; //状态
@property (nonatomic,copy) NSString *rate;  //借款利率
@property (nonatomic,copy) NSString *rate_cat;//借款利率类型
@property (nonatomic,copy) NSString *rebate;//借款期限
@property (nonatomic,copy) NSString *mortorage_community;  //小区名
@property (nonatomic,copy) NSString *seatmortgage; //详细地址
@property (nonatomic,copy) NSString *term; //
@property (nonatomic,copy) NSString *uidString;



//@property (nonatomic,copy) NSString *app_id;
//@property (nonatomic,copy) NSString *applyclose;
//@property (nonatomic,copy) NSString *applyclosefrom;
//@property (nonatomic,copy) NSString *pid;
//@property (nonatomic,copy) NSString *product_id;

@end
