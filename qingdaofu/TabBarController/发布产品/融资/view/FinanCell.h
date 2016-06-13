//
//  FinanCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanCell : UITableViewCell

@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UIButton *typeButton;
@property (nonatomic,strong) UILabel *rentLabel;
@property (nonatomic,strong) UITextField *rentTextField;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
