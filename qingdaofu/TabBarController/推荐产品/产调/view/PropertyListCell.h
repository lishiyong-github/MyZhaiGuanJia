//
//  PropertyListCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyListCell : UITableViewCell

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) UILabel *spaceLine;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end
