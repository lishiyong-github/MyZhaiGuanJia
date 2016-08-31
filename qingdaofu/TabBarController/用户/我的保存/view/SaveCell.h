//
//  SaveCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveCell : UITableViewCell

@property (nonatomic,strong) UIButton *codeButton;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *actButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
