//
//  ReportSuitViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "PublishingModel.h"

@interface ReportSuitViewController : NetworkViewController

@property (nonatomic,strong) NSString *categoryString;  //2为催收，3为诉讼
@property (nonatomic,strong) PublishingModel *suModel;


@end
