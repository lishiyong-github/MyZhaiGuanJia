//
//  AnotherHomeCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MoneyView.h"
#import "LineLabel.h"

@interface AnotherHomeCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIImageView *typeImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) LineLabel *grayLabel;
@property (nonatomic,strong) MoneyView *moneyView;
@property (nonatomic,strong) MoneyView *pointView;
@property (nonatomic,strong) MoneyView *rateView;
@property (nonatomic,strong) LineLabel *lineLabel2;
@property (nonatomic,strong) UIButton *firstButton;
@property (nonatomic,strong) UIButton *secondButton;
@property (nonatomic,strong) UIButton *thirdButton;



@end
