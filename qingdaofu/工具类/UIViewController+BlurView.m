//
//  UIViewController+BlurView.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIViewController+BlurView.h"
#import <objc/runtime.h>
#import "UpwardTableView.h"

@implementation UIViewController (BlurView)

//- (UIView *)blurView
//{
//    UIView *view = objc_getAssociatedObject(self, @selector(blurView));
//    if (!view) {
////        view
//    }
//    return view;
//}

- (void)showBlurWith:(NSArray *)array andTitle:(NSString *)title finishBlock:(void (^)(NSString *))finishBlock
{
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:9998];
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        [self.view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        tableView = [UpwardTableView newAutoLayoutView];
        [self.view addSubview:tableView];
        [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    }
    [tableView setUpwardDataList:array];
    tableView.heightTableConstraints.constant = (array.count+1) * 40;
    QDFWeak(tableView);
    if (finishBlock) {
        [tableView setDidSelectedRow:^(NSString *text) {
            [tagView removeFromSuperview];
            [weaktableView removeFromSuperview];
            finishBlock(text);
        }];
    }
}

@end
