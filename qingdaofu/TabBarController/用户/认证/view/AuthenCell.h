//
//  AuthenCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIImageView *aImageView;
@property (nonatomic,strong) UILabel *bLabel;
@property (nonatomic,strong) UILabel *cLabel;
@property (nonatomic,strong) UILabel *dLabel;
@property (nonatomic,strong) UIButton *AuthenButton;

@end
