//
//  EvaluatePhotoCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEOStarView.h"
#import "TakePictureCell.h"

@interface EvaluatePhotoCell : UITableViewCell

@property (nonatomic,strong) NSLayoutConstraint *topTextConstraints;

@property (nonatomic,strong) UIButton *evaNameButton;  //评价人头像
@property (nonatomic,strong) UILabel *evaNameLabel;  //评价人名字
@property (nonatomic,strong) UILabel *evaTimeLabel;  //评价时间
@property (nonatomic,strong) LEOStarView *evaStarImage;  //星级
@property (nonatomic,strong) UILabel *evaTextLabel;  //内容
@property (nonatomic,strong) UIButton *evaProImageView1; //图片
@property (nonatomic,strong) UIButton *evaProImageView2; //图片

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
