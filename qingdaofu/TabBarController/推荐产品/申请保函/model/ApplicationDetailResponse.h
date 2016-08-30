//
//  ApplicationDetailResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class ApplicationModel;

@interface ApplicationDetailResponse : BaseModel

@property (nonatomic,strong) ApplicationModel *model;

@end
