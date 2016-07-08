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

@interface PublishingResponse : BaseModel

/* 产品详情  */
@property (nonatomic,copy) NSString *creditor;
@property (nonatomic,strong) PublishingModel *product;
@property (nonatomic,copy) NSString *uidString;
@property (nonatomic,strong) NSArray *borrowinginfos;  //债务人信息
@property (nonatomic,strong) DebtModel *creditorfiles; //债权文件
@property (nonatomic,strong) NSArray *creditorinfos;//债权人信息
@property (nonatomic,copy) NSString *guaranteemethods;
@property (nonatomic,copy) NSString *car; //车信息
@property (nonatomic,copy) NSString *license;//车牌类型
@property (nonatomic,copy) NSString *state;  //判断有没有认证

/* 代理人详情 */
@property (nonatomic,strong) NSMutableArray *user;

@end
