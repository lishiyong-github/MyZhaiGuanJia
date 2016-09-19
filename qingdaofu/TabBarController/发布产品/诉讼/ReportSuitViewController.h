//
//  ReportSuitViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "PublishingModel.h"
#import "PublishingResponse.h"

@interface ReportSuitViewController : NetworkViewController

@property (nonatomic,strong) NSString *categoryString;  //2为催收，3为诉讼
@property (nonatomic,strong) PublishingResponse *suResponse;
@property (nonatomic,strong) NSString *tagString;  //1.直接发布；2.保存中修改发布／3.我的发布（发布中）的修改发布

@end
