//
//  PowerAddressCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerAddressCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIButton *actButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
