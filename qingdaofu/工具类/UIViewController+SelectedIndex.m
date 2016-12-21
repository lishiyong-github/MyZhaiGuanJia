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
- (void)setSelectedIndex:(NSInteger)index andType:(NSString *)type //1-跳转至首页，其他跳转至相应页面
{
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([type integerValue] == 0) {
        tabBarController.selectedViewController = tabBarController.viewControllers[index];
    }else if ([type integerValue] == 1){
        tabBarController.selectedViewController = tabBarController.viewControllers.firstObject;
    }

    UITabBar *tabBar = tabBarController.tabBar;
    for (UIView *view in tabBar.subviews) {
        if ([view isKindOfClass:[TabBar class]]) {
            for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[TabBarItem class]]) {
                TabBarItem *item = (TabBarItem *)subView;
                if ([type integerValue] == 0) {
                    if ([item isEqual:view.subviews[index+1]]) {
                        item.selected = YES;
                    }else{
                        item.selected = NO;
                    }
                    
                }else if ([type integerValue] == 1){
                    if ([item isEqual:view.subviews[index]]) {
                        item.selected = YES;
                    }else{
                        item.selected = NO;
                    }
                }
            }
            }
        }
    }
}

//    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tabBarController.selectedViewController = tabBarController.viewControllers.lastObject;
//    UITabBar *tabbar = tabBarController.tabBar;
//    for (UIView *view in tabbar.subviews) {
//        if ([view isKindOfClass:[TabBar class]]) {
//            for (UIView *subView in view.subviews) {
//                if ([subView isKindOfClass:[TabBarItem class]]) {
//                    TabBarItem *item = (TabBarItem *)subView;
//                    item.selected = NO;
//                    if ([item isEqual:view.subviews[index]]) {
//                        item.selected = YES;
//                    }
//                }
//            }
//        }
//    }
//}
@end
