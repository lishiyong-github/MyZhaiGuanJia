//
//  HouseChooseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

@interface HouseChooseViewController : BaseViewController

@property (nonatomic,strong) void (^didSelectedRow)(NSString *);

@end
