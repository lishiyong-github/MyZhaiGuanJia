//
//  AddMyAgentViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "UserModel.h"
#import "CompleteResponse.h"

@interface AddMyAgentViewController : NetworkViewController

@property (nonatomic,strong) NSString *agentFlagString;
@property (nonatomic,strong) UserModel *model;
@property (nonatomic,strong) CompleteResponse *completeModel;

@property (nonatomic,strong) void (^didSaveModel)(UserModel *);

@end
