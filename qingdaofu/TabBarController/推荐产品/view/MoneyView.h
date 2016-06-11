//
//  MoneyView.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>


//45+29+14
@interface MoneyView : UIView

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;

@property (nonatomic,assign) CGFloat aH;

@end
