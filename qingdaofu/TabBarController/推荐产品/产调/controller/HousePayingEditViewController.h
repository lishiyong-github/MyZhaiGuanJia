//
//  HousePayingEditViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface HousePayingEditViewController : NetworkViewController

@property (nonatomic,strong) NSString *areaString;
@property (nonatomic,strong) NSString *addressString;
@property (nonatomic,strong) NSString *phoneString;
@property (nonatomic,strong) NSString *idString; //产调查询ID
@property (nonatomic,strong) NSString *moneyString;

@property (nonatomic,strong) NSString *actString;  //表明返回操作，1-直接返回，2-先返回再进入支付页面

@property (nonatomic,strong) void (^didEditMessage)(NSDictionary *);

@end
