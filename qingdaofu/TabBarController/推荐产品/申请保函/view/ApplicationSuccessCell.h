//
//  ApplicationSuccessCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationSuccessCell : UITableViewCell

@property (nonatomic,strong) UIImageView *appImageView;
@property (nonatomic,strong) UILabel *appLabel1;
@property (nonatomic,strong) UILabel *appLine;
@property (nonatomic,strong) UILabel *appLabel2;
@property (nonatomic,strong) UIButton *appButton1;
@property (nonatomic,strong) UIButton *appButton2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
