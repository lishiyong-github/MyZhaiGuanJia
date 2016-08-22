//
//  ProDetailNumberCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailHeadFootView.h"

@interface ProDetailNumberCell : UITableViewCell

@property (nonatomic,strong) ProDetailHeadFootView *numberButton1;
@property (nonatomic,strong) ProDetailHeadFootView *numberButton2;
@property (nonatomic,strong) ProDetailHeadFootView *numberButton3;

@property (nonatomic,assign) BOOL didSetupConstraints;


@end
