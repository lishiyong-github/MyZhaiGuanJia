//
//  SuitBaseView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuitBaseView : UIView

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UISegmentedControl *segment;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
