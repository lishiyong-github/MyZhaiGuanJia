//
//  SuitBaseCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitBaseCell : UITableViewCell

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UISegmentedControl *segment;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) void (^didSelectedSeg)(NSInteger seg);

@end
