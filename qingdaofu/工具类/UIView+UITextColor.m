//
//  UIView+UITextColor.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIView+UITextColor.h"

@implementation UIView (UITextColor)

- (NSMutableAttributedString *)setAttributeString:(NSString *)firstString withColor:(UIColor *)firstColor andSecond:(NSString *)secondString withColor:(UIColor *)secondColor withFont:(CGFloat)font
{
    NSString *str = [NSString stringWithFormat:@"%@%@",firstString,secondString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeString setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:firstColor} range:NSMakeRange(0, firstString.length)];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSForegroundColorAttributeName:secondColor} range:NSMakeRange(firstString.length, secondString.length)];
    
    return attributeString;
}

@end
