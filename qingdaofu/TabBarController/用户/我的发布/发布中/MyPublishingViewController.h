//
//  MyPublishingViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "ReleaseResponse.h"

@interface MyPublishingViewController : NetworkViewController

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categaryString;
@property (nonatomic,strong) ReleaseResponse *reResponse;

@end
