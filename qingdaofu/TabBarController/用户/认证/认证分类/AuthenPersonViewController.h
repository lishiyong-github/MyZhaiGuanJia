//
//  AuthenPersonViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

#import "CompetetesResponse.h"
#import "CertificationModel.h"
@interface AuthenPersonViewController : NetworkViewController

@property (nonatomic,strong) CompetetesResponse *respnseModel;
@property (nonatomic,strong) NSString *typeAuthen;  //1-update or 0-add
@property (nonatomic,strong) NSString *categoryString;  //1:个人；2:律所；3:公司

@end
