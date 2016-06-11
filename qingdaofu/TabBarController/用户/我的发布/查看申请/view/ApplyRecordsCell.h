//
//  ApplyRecordsCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLabel.h"

@interface ApplyRecordsCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *personLabel;
@property (nonatomic,strong) LineLabel *lineLabel11;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) LineLabel *lineLabel12;
@property (nonatomic,strong) UIButton *actButton;

@end
