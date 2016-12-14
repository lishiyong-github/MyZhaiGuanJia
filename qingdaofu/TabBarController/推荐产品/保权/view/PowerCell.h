//
//  PowerCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerCell : UITableViewCell

@property (nonatomic,strong) UIButton *orderButton;
@property (nonatomic,strong) UIImageView *moreImageView;
@property (nonatomic,strong) UIButton *statusButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
