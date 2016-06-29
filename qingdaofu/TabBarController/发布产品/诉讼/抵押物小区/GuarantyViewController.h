//
//  GuarantyViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface GuarantyViewController : NetworkViewController

//（省 、市、 区）、小区地址、详细地址
@property (nonatomic,strong) void (^didSelectedArea)(NSString*,NSString*);

@end
