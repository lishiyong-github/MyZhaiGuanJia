//
//  CompetetesResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/12/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@class CertificationModel;

@interface CompetetesResponse : BaseModel
@property (nonatomic,strong) CertificationModel *certification;//认证信息
@property (nonatomic,copy) NSString *completionRate; //完整度


@end
