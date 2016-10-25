//
//  ChangeMobileViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface ChangeMobileViewController : NetworkViewController

@property (nonatomic,strong) NSString *oldMobile;  //旧手机号码
@property (nonatomic,strong) NSString *oldCode;  //旧手机验证码

@end
