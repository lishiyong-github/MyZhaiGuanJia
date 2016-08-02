//
//  PowerCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerCell : UITableViewCell

@property (nonatomic,strong) UILabel *powerMoneyLabel;
@property (nonatomic,strong) UILabel *powerStateLabel;
@property (nonatomic,strong) UILabel *powerLine;
@property (nonatomic,strong) UIButton *powerButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
