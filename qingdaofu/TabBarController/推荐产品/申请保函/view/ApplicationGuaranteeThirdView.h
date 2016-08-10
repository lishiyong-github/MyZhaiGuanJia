//
//  ApplicationGuaranteeThirdView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationGuaranteeThirdView : UIView
@property (nonatomic,strong) void (^didSelectedRow)(NSInteger);

@property (nonatomic,assign) BOOL didSrtupConstraints;


@end
