//
//  UploadFilesViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "DebtModel.h"

@interface UploadFilesViewController : NetworkViewController

@property (nonatomic,strong) NSString *tagString; //1-首次编辑，2-再次编辑
//判断image是本地还是返回的数据
@property (nonatomic,strong) NSMutableDictionary *filesDic;
@property (nonatomic,strong) void (^chooseImages)(NSDictionary *);

@end
