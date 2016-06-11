//
//  EvaluateSendCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateSendCell : UITableViewCell

@property (nonatomic,strong) void (^didSelectedIndex)(NSInteger);

@property (nonatomic,strong) UILabel *evaNameLabel;
@property (nonatomic,strong) UILabel *evaTimeLabel;
@property (nonatomic,strong) UIImageView *evaStarImageView;
@property (nonatomic,strong) UILabel *evaTextLabel;

@property (nonatomic,strong) UIImageView *evaProImageView1;
@property (nonatomic,strong) UIImageView *evaProImageView2;

@property (nonatomic,strong) UIButton *evaProductButton;
@property (nonatomic,strong) UIButton *evaInnnerButton;
@property (nonatomic,strong) UIImageView *evaInnerImage;

@property (nonatomic,strong) UIButton *evaDeleteButton;
@property (nonatomic,strong) UIButton *evaAdditionButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
