//
//  CheckDetailPublishViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface CheckDetailPublishViewController : NetworkViewController

@property (nonatomic,strong) NSString *typeString;  //类别（接单方或发布方或申请人）
@property (nonatomic,strong) NSString *typeDegreeString;  //1-不显示电话，发布方（申请中1，处理中，终止，结案）、接单方（发布中1，处理中，终止，结案）

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *pidString;
//@property (nonatomic,strong) NSString *evaTypeString;  //评价类型（evaluate(收到的评价) ／launchevaluation(发出的评级)）


@property (nonatomic,strong) NSString *navTitle; // title
@property (nonatomic,strong) NSString *productid;
@property (nonatomic,strong) NSString *userid;

@end
