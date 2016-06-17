//
//  UserModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *isstop;    //0：正常，1:停用
@property (nonatomic,copy) NSString *username;  //代理人名字
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *auth_key;
@property (nonatomic,copy) NSString *cardno; //证件号
@property (nonatomic,copy) NSString *created_at;  //创建时间
@property (nonatomic,copy) NSString *password_hash;  //密码
@property (nonatomic,copy) NSString *password_reset_token;   
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *tjmobile;  //推荐人手机号码
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *updated_at;   //更新时间
@property (nonatomic,copy) NSString *zycardno;  //只有律所认证的用户添加代理人才会有资格证其他没有

//申请记录字段
@property (nonatomic,copy) NSString *app_id;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *uidInner;

@end
