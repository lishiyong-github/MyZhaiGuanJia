//
//  PaceViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"
#import "ScheduleModel.h"

@interface PaceViewController : BaseViewController

@property (nonatomic,strong) ScheduleModel *model;
@property (nonatomic,strong) NSMutableArray *scheArray;

@end
