//
//  BaseCommitView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCommitButton.h"

@interface BaseCommitView : UIButton

@property (nonatomic,strong) BaseCommitButton *button;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
