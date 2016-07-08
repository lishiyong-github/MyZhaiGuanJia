//
//  UploadFilesViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "PublishingResponse.h"

@interface UploadFilesViewController : NetworkViewController

@property (nonatomic,strong) NSString *fileTypeString;  //判断image是本地还是返回的数据
@property (nonatomic,strong) PublishingResponse *filesResponse;

@property (nonatomic,strong) void (^chooseImages)(NSDictionary *);

@end
