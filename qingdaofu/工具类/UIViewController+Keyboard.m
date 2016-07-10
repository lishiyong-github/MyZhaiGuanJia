//
//  UIViewController+Keyboard.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIViewController+Keyboard.h"

@implementation UIViewController (Keyboard)
@dynamic touchPoint;
- (CGPoint)touchPoint
{
    NSString *point = objc_getAssociatedObject(self, @selector(touchPoint));
    return CGPointFromString(point);
}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    objc_setAssociatedObject(self, @selector(touchPoint), NSStringFromCGPoint(touchPoint), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = CGRectFromString([NSString stringWithFormat:@"%@",notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"]]);
    if (CGRectContainsPoint(keyboardFrame, self.touchPoint)) {
        CGFloat height = self.touchPoint.y - keyboardFrame.origin.y;
        [UIView animateWithDuration:0.7 animations:^{
            self.view.frame = CGRectMake(0, - height, self.view.width, self.view.height);
        }];
    }
}

- (void)keyboardWillhide{
    [UIView animateWithDuration:0.7 animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.width, self.view.height);
    }];
}


@end
