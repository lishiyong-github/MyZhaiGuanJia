//
//  StarCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEOStarView.h"

@interface StarCell : UITableViewCell

@property (nonatomic,strong) UILabel *starLabel1;
@property (nonatomic,strong) UILabel *starLabel2;
@property (nonatomic,strong) UILabel *starLabel3;

@property (nonatomic,strong) LEOStarView *starView1;
@property (nonatomic,strong) LEOStarView *starView2;
@property (nonatomic,strong) LEOStarView *starView3;

@property (nonatomic,assign) BOOL didSetupConstarints;

@property (nonatomic,strong) void (^didSelectedStar)(NSInteger);

@end
