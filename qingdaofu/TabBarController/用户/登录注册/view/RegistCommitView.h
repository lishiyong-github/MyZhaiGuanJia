//
//  RegistCommitView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseCommitButton.h"

@interface RegistCommitView : UIView

@property (nonatomic,strong) BaseCommitButton *commitButton;
@property (nonatomic,strong) UIButton *tagButton;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *contentButton;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) void (^didSetectedButton)(NSInteger);

@end
