//
//  ReportSuitViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface ReportSuitViewController : NetworkViewController

@property (nonatomic,strong) NSString *tagString;  //1.直接发布；2.保存中修改发布／3.我的发布（发布中）的修改发布
@property (nonatomic,strong) NSString *productid;

@end
