//
//  DetailBaseView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailBaseView : UIView

@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UIButton *button1;

@property (nonatomic,assign) BOOL didSetupConstraints;
@end
