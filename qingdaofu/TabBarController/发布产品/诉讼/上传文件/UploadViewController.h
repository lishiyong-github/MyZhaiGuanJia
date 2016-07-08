//
//  UploadViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"
#import "PublishingResponse.h"
#import "DebtModel.h"

@interface UploadViewController : BaseViewController

//选取图片
@property (nonatomic,strong) void (^uploadImages)(NSArray *images);

//0.公证书；1.借款合同；2.他项权证；3.收款凭证；4.收据；5.还款凭证
@property (nonatomic,assign) NSInteger typeUpInt;
@property (nonatomic,strong) DebtModel *filesModel;

@end
