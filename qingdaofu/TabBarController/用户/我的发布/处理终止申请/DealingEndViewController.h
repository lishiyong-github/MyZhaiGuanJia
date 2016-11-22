//
//  DealingEndViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface DealingEndViewController : NetworkViewController

@property (nonatomic,strong) NSString *terminationid;
@property (nonatomic,strong) NSString *isShowAct;  //1-显示操作按钮，2-不显示

@end
