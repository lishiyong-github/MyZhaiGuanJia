//
//  MailResponseModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MailModel;

@interface MailResponseModel : NSObject


@property (nonatomic,copy) NSString *contactsid; //联系人ID
@property (nonatomic,copy) NSString *create_at; // 添加时间
@property (nonatomic,copy) NSString *create_by; //添加人
@property (nonatomic,copy) NSString *modify_at;   //修改时间
@property (nonatomic,copy) NSString *modify_by;  //修改人
@property (nonatomic,copy) NSString *status;  //状态类型（0为请求中 1为同意申请，2不同意）
@property (nonatomic,copy) NSString *userid; //联系人用户ID
@property (nonatomic,copy) NSString *validflag;

//本接单已存在经办人将会有数据
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *ordersid;
@property (nonatomic,copy) NSString *productid;
@property (nonatomic,copy) NSString *operatorid;


//用户相关信息
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;


@end
