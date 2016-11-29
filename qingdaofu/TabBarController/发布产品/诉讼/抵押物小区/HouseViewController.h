//
//  HouseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface HouseViewController : NetworkViewController

@property (nonatomic,strong) void (^didSelectedRow)(NSString *,NSString *,NSString*,NSString*,NSString*,NSString *);

@end
