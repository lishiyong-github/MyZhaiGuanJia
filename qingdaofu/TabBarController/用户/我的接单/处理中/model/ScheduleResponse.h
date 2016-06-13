//
//  ScheduleResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface ScheduleResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *disposing;
@property (nonatomic,copy) NSString *uid;

@end
