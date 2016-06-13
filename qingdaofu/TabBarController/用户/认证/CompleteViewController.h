//
//  CompleteViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "CompleteResponse.h"

@interface CompleteViewController : NetworkViewController

@property (nonatomic,strong) NSString *authenTypeString;
@property (nonatomic,strong) CompleteResponse *responseModel;

@end
