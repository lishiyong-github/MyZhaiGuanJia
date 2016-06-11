//
//  CompletePhotoView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletePhotoView : UIView

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
