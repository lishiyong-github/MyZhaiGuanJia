//
//  PublishingResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@class PublishingModel;
@class UserModel;
@class DebtModel;
@class UserNameModel;

@interface PublishingResponse : BaseModel

/* 产品详情  */
@property (nonatomic,copy) NSString *creditor;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,strong) DebtModel *creditorfile; //债权文件
@property (nonatomic,strong) NSMutableArray *creditorinfo;//债权人信息
@property (nonatomic,strong) NSMutableArray *borrowinginfo;  //债务人信息

@property (nonatomic,copy) NSString *car; //车信息
@property (nonatomic,copy) NSString *uidString;
@property (nonatomic,copy) NSString *guaranteemethods;
@property (nonatomic,copy) NSString *license;//车牌类型
@property (nonatomic,copy) NSString *state;  //判断有没有认证(1-已认证，其他－未认证)

@property (nonatomic,strong) PublishingModel *product;
@property (nonatomic,strong) UserNameModel *username;  //发布方详情

//省市区的名字
@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *district_id;
@property (nonatomic,copy) NSString *place_province_id;
@property (nonatomic,copy) NSString *place_city_id;
@property (nonatomic,copy) NSString *place_district_id;


/* 代理人详情 */
@property (nonatomic,strong) NSMutableArray *user;

@end
