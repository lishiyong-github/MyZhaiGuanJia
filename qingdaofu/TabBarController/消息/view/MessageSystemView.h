//
//  MessageSystemView.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSystemView : UIButton


@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *imageButton;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *timeButton;


@end
