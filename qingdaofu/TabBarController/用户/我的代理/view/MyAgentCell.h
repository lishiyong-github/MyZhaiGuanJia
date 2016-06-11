//
//  MyAgentCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAgentCell : UITableViewCell

@property (nonatomic,strong) UILabel *agentNameLabel;
@property (nonatomic,strong) UIButton *agentEditButton;
@property (nonatomic,strong) UILabel *agentTelLabel;
@property (nonatomic,strong) UILabel *agentIDLabel;
@property (nonatomic,strong) UILabel *agentCerLabel;
@property (nonatomic,strong) UILabel *agentPassLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
