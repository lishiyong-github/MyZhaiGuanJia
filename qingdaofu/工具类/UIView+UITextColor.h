//
//  UIView+UITextColor.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UITextColor)

- (NSMutableAttributedString *)setAttributeString:(NSString *)firstString withColor:(UIColor *)firstColor andSecond:(NSString *)secondString withColor:(UIColor *)secondColor withFont:(CGFloat)font;


@end
