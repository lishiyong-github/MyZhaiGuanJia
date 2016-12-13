//
//  CompleteResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class CertificationModel;
@class ImageModel;
@class CheckEvaluateResponse;

@interface CompleteResponse : BaseModel

@property (nonatomic,strong) CertificationModel *certification;//认证信息
@property (nonatomic,copy) NSString *completionRate;  //完成度
@property (nonatomic,copy) NSString *canContacts;  //能否打电话
@property (nonatomic,strong) CheckEvaluateResponse *commentdata;  //评论相关信息

///////用户信息
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *isSetPassword;  //0-设置密码，1-修改密码
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *operatorDo;
@property (nonatomic,strong) ImageModel *pictureimg;
@property (nonatomic,copy) NSString *pictureurl;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;



@end