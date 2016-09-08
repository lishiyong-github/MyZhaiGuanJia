//
//  UIViewController+AlertView.h
//  qingdaofu
//
//  Created by zhixiang on 16/9/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertView)

@property (nonatomic,strong) void (^didSelelctedAlert)(NSInteger);

//@property (nonatomic,strong) NSString *ty;

/********** type
 1-image+label+button
 2-label+label+button
 ***********/
- (void)showAlertViewWithType:(NSString *)type;

@end
