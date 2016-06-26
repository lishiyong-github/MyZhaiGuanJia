//
//  DebtCreditMessageViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

@interface DebtCreditMessageViewController : BaseViewController

@property (nonatomic,strong) NSString *tagString;  //1位首次添加，2为再次添加
@property (nonatomic,strong) void (^didEndEditting)(NSDictionary *);

@end
