//
//  MyReleaseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RefreshViewController.h"

@interface MyReleaseViewController : RefreshViewController

/*
 1.all -- 全部
 2.ing -- 已发布
 3.deal -- 处理中
 4.end -- 终止
 5.close -- 结案
 */
@property (nonatomic,strong) NSString *rFlagString;
@property (nonatomic,strong) NSString *progreStatus;


@end
