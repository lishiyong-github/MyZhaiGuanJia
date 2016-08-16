//
//  PersonCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell

@property (nonatomic,strong) UIButton *pictureButton1;
@property (nonatomic,strong) UIButton *pictureButton2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
