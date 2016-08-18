//
//  ApplicationCourtViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface ApplicationCourtViewController : NetworkViewController

@property (nonatomic,strong) void (^didSelectedRow)(NSString *,NSString *);

@property (nonatomic,strong) NSString *area_pidString; //省
@property (nonatomic,strong) NSString *area_idString;//市

@end
