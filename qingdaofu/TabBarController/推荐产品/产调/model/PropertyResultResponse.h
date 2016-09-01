//
//  PropertyResultResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class PropertyResultOnesModel;

@interface PropertyResultResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) PropertyResultOnesModel *ones;

@end
