//
//  UIViewController+BlurView.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BlurView)

- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array andTitle:(NSString *)title finishBlock:(void(^)(NSString *text,NSInteger row))finishBlock;

- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array withTop:(CGFloat)top finishBlock:(void(^)(NSString *text,NSInteger row))finishBlock;

- (void)showBlurInView:(UIView *)view withType:(NSString *)type andCategory:(NSString *)category andArray:(NSArray *)array finishBlock:(void(^)())finishBlock;//type:add or edit ,, category:房产抵押，机动车抵押，合同纠纷

- (void)hiddenBlurView;

@end
