//
//  CompleteResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class CertificationModel;

@interface CompleteResponse : BaseModel

@property (nonatomic,strong) CertificationModel *certification;//认证信息

@property (nonatomic,copy) NSString *completionRate;  //完成度
//@property (nonatomic,copy) NSString *uid;
//@property (nonatomic,copy) NSString *user;


///////用户信息
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *pictureimg;
@property (nonatomic,copy) NSString *pictureurl;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *username;



@end