//
//  UploadFilesViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface UploadFilesViewController : NetworkViewController

@property (nonatomic,strong) void (^uploadImages)(NSDictionary *);

@end
