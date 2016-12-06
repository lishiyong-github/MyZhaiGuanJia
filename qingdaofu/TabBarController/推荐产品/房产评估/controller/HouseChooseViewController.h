//
//  HouseChooseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface HouseChooseViewController : NetworkViewController

@property (nonatomic,strong) void (^didSelectedRow)(NSString *,NSString *,NSInteger);//name , id,row 

@property (nonatomic,strong) NSString *cateString; //1-房产评估，2-产调查询

@end
