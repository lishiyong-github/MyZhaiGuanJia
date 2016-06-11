//
//  ReportSuccessCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportSuccessCell : UITableViewCell

@property (nonatomic,strong) UILabel *suTimeLabel;
@property (nonatomic,strong) UILabel *suTypeLabel;
@property (nonatomic,strong) UILabel *suStateLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
