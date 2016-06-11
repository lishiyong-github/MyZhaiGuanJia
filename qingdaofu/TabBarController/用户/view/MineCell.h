//
//  MineCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseLabel.h"
#import "UserButton.h"

@interface MineCell : UITableViewCell

@property (nonatomic,strong) UIButton *topNameButton;
@property (nonatomic,strong) UIButton *topGoButton;
@property (nonatomic,strong) UILabel *linelabel;
@property (nonatomic,strong) UserButton *button1;
@property (nonatomic,strong) UserButton *button2;
@property (nonatomic,strong) UserButton *button3;
@property (nonatomic,strong) UserButton *button4;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
