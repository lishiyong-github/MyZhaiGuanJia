//
//  MyReleaseDetailsViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface MyReleaseDetailsViewController : NetworkViewController

@property (nonatomic,strong) NSString *productid;  //产品详情
@property (nonatomic,strong) NSString *messageid;  //从消息列表查看详情

@end
