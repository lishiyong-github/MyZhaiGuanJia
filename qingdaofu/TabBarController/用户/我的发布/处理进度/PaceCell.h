//
//  PaceCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaceCell : UITableViewCell

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *separateLabel1;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *separateLabel2;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIButton *messageButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

//@property (nonatomic,assign) CGFloat longHeight;
@property (nonatomic,strong) NSLayoutDimension *longHeight;
@property (nonatomic,strong) NSLayoutConstraint *leftConstraints;

@end
