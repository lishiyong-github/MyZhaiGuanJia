//
//  AllEvaluationViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/26.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RefreshViewController.h"

@interface AllEvaluationViewController : RefreshViewController

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *pidString;

@property (nonatomic,strong) NSString *evaTypeString;//评价类型（evaluate(收到的评价) ／launchevaluation(发出的评级)）


@end
