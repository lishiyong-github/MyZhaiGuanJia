//
//  ApplyRecordViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "ApplyRecordModel.h"


@interface ApplyRecordViewController : NetworkViewController

@property (nonatomic,strong) void (^didChooseApplyUser)(ApplyRecordModel*);

@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *categaryStr;

@property (nonatomic,strong) NSString *productid;  //产品ID


@end
