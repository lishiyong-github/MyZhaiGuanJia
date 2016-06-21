//
//  GuarantyViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface GuarantyViewController : NetworkViewController

@property (nonatomic,strong) void (^didSelectedArea)(NSString *,NSString *,NSString *,NSString*);

@end
