//
//  PaceViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"


@interface PaceViewController : NetworkViewController

@property (nonatomic,strong) NSArray *orderLogsArray;  //日志
@property (nonatomic,strong) NSString *personType;  //1-发布方 2-接单方或经办人

@end
