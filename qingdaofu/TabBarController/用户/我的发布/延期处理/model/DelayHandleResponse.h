//
//  DelayHandleResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@class DelayHandleModel;

@interface DelayHandleResponse : BaseModel

@property (nonatomic,strong) DelayHandleModel *data;

@end
