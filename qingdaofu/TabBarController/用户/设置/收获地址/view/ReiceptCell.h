//
//  ReiceptCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReiceptCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
