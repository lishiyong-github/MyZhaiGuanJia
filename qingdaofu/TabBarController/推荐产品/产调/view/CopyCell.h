//
//  CopyCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopyCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imageViewcc;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIButton *soButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
