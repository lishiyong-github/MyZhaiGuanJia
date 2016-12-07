//
//  CheckDetailPublishViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface CheckDetailPublishViewController : NetworkViewController

@property (nonatomic,strong) NSString *navTitle; // title
@property (nonatomic,strong) NSString *productid;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *isShowPhone;  //是否显示电话  1-不显示

@end
