//
//  SystemMessageCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contenLabel;

@end
