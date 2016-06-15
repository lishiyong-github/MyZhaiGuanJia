//
//  PaceCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaceCell : UITableViewCell

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *separateLabel1;
@property (nonatomic,strong) UILabel *separateLabel2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
