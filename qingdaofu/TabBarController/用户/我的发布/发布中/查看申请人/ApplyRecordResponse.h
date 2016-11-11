//
//  ApplyRecordResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface ApplyRecordResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *user;

@property (nonatomic,strong) NSMutableArray *apply;

@end
