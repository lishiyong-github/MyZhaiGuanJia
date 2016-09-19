//
//  NewProductResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class CertificationModel;
@class PublishingModel;
@class NumberModel;
@class CreditorFileModel;

@interface NewProductResponse : BaseModel

@property (nonatomic,copy) NSString *appCount;
@property (nonatomic,strong) CertificationModel *certification; //认证信息
@property (nonatomic,strong) PublishingModel *data; //产品详情
@property (nonatomic,strong) NumberModel *number;  //申请、收藏次数
@property (nonatomic,strong) CreditorFileModel *add;  //债权文件
@end
