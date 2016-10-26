//
//  MyPublishingViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
//#import "ReleaseResponse.h"

@interface MyPublishingViewController : NetworkViewController

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categaryString;
@property (nonatomic,strong) NSString *app_idString;

@property (nonatomic,strong) NSString *productid;  //产品详情
@property (nonatomic,strong) NSString *messageid;  //从消息列表查看详情

@end
