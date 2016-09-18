//
//  CaseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface CaseViewController : NetworkViewController

@property (nonatomic,strong) void (^didEndFinish)(NSString *);

@property (nonatomic,strong) NSString *caseString;//显示经典案例的url
@property (nonatomic,strong) NSString *toString;  //1-编辑经典案例 0-显示经典案例

@end
