//
//  DebtCreditMessageViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

@interface DebtCreditMessageViewController : BaseViewController

@property (nonatomic,strong) NSString *tagString;  //0位首次添加，1为再次添加
@property (nonatomic,strong) void (^didEndEditting)(NSDictionary *);

@end
