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

@property (nonatomic,strong) CertificationModel *certification;
@property (nonatomic,copy) NSString *completionRate;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *user;

@end
