//
//  UIViewController+Keyboard.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Keyboard)
@property (nonatomic,assign) CGPoint touchPoint;

- (void)addKeyboardObserver;
- (void)removeKeyboardObserver;

@end
