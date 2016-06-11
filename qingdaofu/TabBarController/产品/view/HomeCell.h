//
//  HomeCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyView.h"

//156H
@interface HomeCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIImageView *typeImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *recommendimageView;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *grayLabel;
@property (nonatomic,strong) MoneyView *moneyView;
@property (nonatomic,strong) MoneyView *pointView;
@property (nonatomic,strong) MoneyView *rateView;

@end
