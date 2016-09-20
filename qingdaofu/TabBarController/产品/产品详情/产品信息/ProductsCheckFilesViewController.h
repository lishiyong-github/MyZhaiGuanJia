//
//  ProductsCheckFilesViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "PublishingResponse.h"
#import "CreditorFileModel.h"
#import "DebtModel.h"  //债权文件

@interface ProductsCheckFilesViewController : NetworkViewController

@property (nonatomic,strong) PublishingResponse *fileResponse;
@property (nonatomic,strong) CreditorFileModel *crediFileModel;
@property (nonatomic,strong) DebtModel *debtFileModel; //产品详情

@end
