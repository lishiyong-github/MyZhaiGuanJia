//
//  UserPublishCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPublishCell : UITableViewCell

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UILabel *lined1;
@property (nonatomic,strong) UILabel *lined2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
