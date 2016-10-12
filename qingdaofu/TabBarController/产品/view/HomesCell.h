//
//  HomesCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/12.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyView.h"

@interface HomesCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UILabel *nameLabel;  //code
@property (nonatomic,strong) UILabel *addressLabel; //合同履行地

@property (nonatomic,strong) UILabel *typeLabel1;//债权类型
@property (nonatomic,strong) UILabel *typeLabel2;//债权类型
@property (nonatomic,strong) UILabel *typeLabel3;//债权类型
@property (nonatomic,strong) UILabel *typeLabel4;//债权类型

@property (nonatomic,strong) MoneyView *moneyView;//委托费用
@property (nonatomic,strong) MoneyView *pointView;//委托金额
@property (nonatomic,strong) MoneyView *rateView;//违约期限

@end
