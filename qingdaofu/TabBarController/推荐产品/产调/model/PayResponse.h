//
//  PayResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class PayModel;

@interface PayResponse : BaseModel

@property (nonatomic,strong) PayModel *paydata;

@end
