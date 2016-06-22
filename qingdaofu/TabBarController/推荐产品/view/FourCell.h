//
//  FourCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/22.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourCell : UITableViewCell

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) void (^didClickButton)(NSInteger);
@end
