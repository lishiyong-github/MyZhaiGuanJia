//
//  DebtCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebtCell : UITableViewCell

@property (nonatomic,strong) UILabel *debtNameLabel;
@property (nonatomic,strong) UIButton *debtEditButton;
@property (nonatomic,strong) UILabel *debtTelLabel;
@property (nonatomic,strong) UILabel *debtAddressLabel;
@property (nonatomic,strong) UILabel *debtAddressLabel1;
@property (nonatomic,strong) UILabel *debtIDLabel;
@property (nonatomic,strong) UIImageView *debtImageView1;
@property (nonatomic,strong) UIImageView *debtImageView2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
