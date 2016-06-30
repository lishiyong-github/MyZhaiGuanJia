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

@property (nonatomic,strong) UILabel *evaNameLabel;  //评价人
@property (nonatomic,strong) UILabel *evaTimeLabel;  //评价时间
@property (nonatomic,strong) LEOStarView *evaStarImage;  //星级
@property (nonatomic,strong) UILabel *evaTextLabel;  //内容
@property (nonatomic,strong) UIImageView *evaProImageView1; //图片
@property (nonatomic,strong) UIImageView *evaProImageView2; //图片

@property (nonatomic,strong) UIButton *evaProductButton;
@property (nonatomic,strong) UIButton *evaInnnerButton;
@property (nonatomic,strong) UIImageView *evaInnerImage;

//无内容时的提示信息
@property (nonatomic,strong) UIButton *remindImageButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
