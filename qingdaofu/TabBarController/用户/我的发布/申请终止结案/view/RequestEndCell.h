//
//  RequestEndCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestEndCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *reasonButton1;
@property (nonatomic,strong) UIButton *reasonButton2;
@property (nonatomic,strong) UIButton *reasonButton3;
@property (nonatomic,strong) UIButton *reasonButton4;

@property (nonatomic,strong) void (^didSelectedButton)(UIButton *);

@end
