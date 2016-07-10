//
//  MineUserCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineUserCell : UITableViewCell

@property (nonatomic,strong) UIButton *userNameButton;
@property (nonatomic,strong) UIButton *userActionButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSLayoutConstraint *widthActConstraints;
- (void)swapUserName;
@end
