//
//  AuthenCompanyViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "CompleteResponse.h"


@interface AuthenCompanyViewController : NetworkViewController
@property (nonatomic,strong) CompleteResponse *responseModel;

@end
