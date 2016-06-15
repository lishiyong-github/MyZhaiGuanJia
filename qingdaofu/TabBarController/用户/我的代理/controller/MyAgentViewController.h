//
//  MyAgentViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "UserModel.h"

@interface MyAgentViewController : NetworkViewController

@property (nonatomic,strong) UserModel *agentModel;  //是否停用

@end
