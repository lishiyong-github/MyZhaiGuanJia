//
//  BidOneCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidOneCell : UITableViewCell


@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *oneButton;
@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
