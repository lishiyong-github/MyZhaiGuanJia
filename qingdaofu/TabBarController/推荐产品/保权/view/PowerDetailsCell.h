//
//  PowerDetailsCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerDetailsCell : UITableViewCell

@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;

@property (nonatomic,strong) UILabel *progress1;
@property (nonatomic,strong) UILabel *progress2;
@property (nonatomic,strong) UILabel *progress3;
@property (nonatomic,strong) UILabel *progress4;

@property (nonatomic,strong) UIButton *point1;
@property (nonatomic,strong) UIButton *point2;
@property (nonatomic,strong) UIButton *point3;
@property (nonatomic,strong) UIButton *point4;

@property (nonatomic,strong) UILabel *line1;
@property (nonatomic,strong) UILabel *line2;
@property (nonatomic,strong) UILabel *line3;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
