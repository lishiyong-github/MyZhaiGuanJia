//
//  EditDebtCreditMessageViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "DebtModel.h"

@interface EditDebtCreditMessageViewController : NetworkViewController

@property (nonatomic,strong) DebtModel *deModel;
@property (nonatomic,strong) NSString *categoryString;  //1：债权人信息，2:债务人信息

@property (nonatomic,strong) void (^didSaveMessage)(DebtModel *);

@end