//
//  ApplyRecordCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRecordCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UILabel *personLabel;
@property (nonatomic,strong) UILabel *lineLabel11;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *lineLabel12;
@property (nonatomic,strong) UIButton *actButton;

@end
