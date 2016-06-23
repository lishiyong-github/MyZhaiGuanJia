//
//  AuthenLawViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "CompleteResponse.h"
#import "CertificationModel.h"


@interface AuthenLawViewController : NetworkViewController
@property (nonatomic,strong) CompleteResponse *responseModel;
@property (nonatomic,strong) NSString *typeAuthen;
@property (nonatomic,strong) NSString *categoryString;  //1:个人；2:律所；3:公司

@end
