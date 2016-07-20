//
//  EvaluateSendCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOStarView.h"

@interface EvaluateSendCell : UITableViewCell

@property (nonatomic,strong) void (^didSelectedIndex)(NSInteger);

@property (nonatomic,strong) UILabel *evaNameLabel;
@property (nonatomic,strong) UILabel *evaTimeLabel;
@property (nonatomic,strong) LEOStarView *evaStarImageView;
@property (nonatomic,strong) UILabel *evaTextLabel;

@property (nonatomic,strong) UIButton *evaProImageViews1;
@property (nonatomic,strong) UIButton *evaProImageViews2;

@property (nonatomic,strong) UIButton *evaProductButton;
@property (nonatomic,strong) UIButton *evaInnnerButton;
@property (nonatomic,strong) UIImageView *evaInnerImage;

@property (nonatomic,strong) UIButton *evaDeleteButton;
@property (nonatomic,strong) UIButton *evaAdditionButton;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSLayoutConstraint *topProConstraints;

@end
