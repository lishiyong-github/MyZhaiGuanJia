//
//  PowerDetailsCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerDetailsCell : UITableViewCell

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;


@property (nonatomic,assign) BOOL didSetupConstraints;

@end
