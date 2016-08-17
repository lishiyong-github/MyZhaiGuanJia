//
//  PowerProtectViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface PowerProtectViewController : NetworkViewController

@property (nonatomic,strong) void (^didSelectedRow)(NSString *,NSString *,NSString*,NSString*,NSString*,NSString *);

@end
