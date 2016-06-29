//
//  DelayResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class DelayModel;
@class PublishingModel;

@interface DelayResponse : BaseModel

@property (nonatomic,strong) DelayModel *delay;
@property (nonatomic,strong) PublishingModel *product;

@end
