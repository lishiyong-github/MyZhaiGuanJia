//
//  HousePayingViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface HousePayingViewController : NetworkViewController

@property (nonatomic,strong) NSString *genarateId;  //生成id
@property (nonatomic,strong) NSString *genarateMoney; //生成金额
@property (nonatomic,strong) NSString *phoneString; //产调电话
@property (nonatomic,strong) NSString *areaString; //产调区域
@property (nonatomic,strong) NSString *addressString; //产调地址

@end
