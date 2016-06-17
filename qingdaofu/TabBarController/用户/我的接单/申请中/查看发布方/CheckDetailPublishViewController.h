//
//  CheckDetailPublishViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RefreshViewController.h"

@interface CheckDetailPublishViewController : RefreshViewController

@property (nonatomic,strong) NSString *typeString;  //类别（接单方或发布方或申请人）

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *pidString;
@property (nonatomic,strong) NSString *evaTypeString;  //评价类型（evaluate(收到的评价) ／launchevaluation(发出的评级)）

@end
