//
//  MyOrderViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

//#import "RefreshViewController.h"
#import "NetworkViewController.h"

@interface MyOrderViewController : NetworkViewController

/*
 1.all -- 全部
 2.apply -- 申请中
 3.deal -- 处理中
 4.end -- 终止
 5.close -- 结案
 */
//@property (nonatomic,strong) NSString *oFlagString;

@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *progresStatus;

@end
