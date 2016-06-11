//
//  EvaluateCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateCell : UITableViewCell

@property (nonatomic,strong) UILabel *evaNameLabel;
@property (nonatomic,strong) UILabel *evaTimeLabel;
@property (nonatomic,strong) UIImageView *evaStarImageView;
@property (nonatomic,strong) UILabel *evaTextLabel;
@property (nonatomic,strong) UIButton *evaProductButton;
@property (nonatomic,strong) UIButton *evaInnnerButton;
@property (nonatomic,strong) UIImageView *evaInnerImage;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end
