//
//  UploadViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadViewController : BaseViewController

@property (nonatomic,strong) void (^uploadImages)(NSDictionary *);

@end
