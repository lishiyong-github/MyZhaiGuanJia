//
//  ReportFootView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportFootView : UIButton

@property (nonatomic,strong) UIButton *footButton;
@property (nonatomic,strong) UILabel *footLabel;


@property (nonatomic,assign) BOOL didSetupConstraints;

@end
