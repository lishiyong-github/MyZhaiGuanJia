//
//  UIViewController+SelectedIndex.m
//  qingdaofu
//
//  Created by shiyong_li on 16/6/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIViewController+SelectedIndex.h"
#import "TabBarItem.h"
#import "TabBar.h"
@implementation UIViewController (SelectedIndex)
- (void)setSelectedIndex:(NSInteger)index
{
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarController.selectedViewController = tabBarController.viewControllers.lastObject;
    UITabBar *tabbar = tabBarController.tabBar;
    for (UIView *view in tabbar.subviews) {
        if ([view isKindOfClass:[TabBar class]]) {
            for (UIView *subView in view.subviews) {
                if ([subView isKindOfClass:[TabBarItem class]]) {
                    TabBarItem *item = (TabBarItem *)subView;
                    item.selected = NO;
                    if ([item isEqual:view.subviews[index]]) {
                        item.selected = YES;
                    }
                }
            }
        }
    }
}
@end
