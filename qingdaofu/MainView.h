//
//  MainView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingleButton.h"

@interface MainView : UIView

@property (nonatomic,strong) SingleButton *pubFiSingleButton;
@property (nonatomic,strong) SingleButton *pubCoSingleButton;
@property (nonatomic,strong) SingleButton *pubSuSingleButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
