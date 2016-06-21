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

- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array andTitle:(NSString *)title finishBlock:(void (^)(NSString *text,NSInteger row))finishBlock
{
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:99998];
    tableView.tableType = @"有";
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        [self.view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        tableView = [UpwardTableView newAutoLayoutView];
        [self.view addSubview:tableView];
        
        if (title) {
            [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        }else{
            [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        }
    }
    
    if (tagView) {//点击蒙板，界面消失
        UIButton *control = [UIButton newAutoLayoutView];
        [tagView addSubview:control];
        [control autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [control autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:tableView];
        [control addAction:^(UIButton *btn) {
            [tagView removeFromSuperview];
            [tableView removeFromSuperview];
        }];
    }
    
    [tableView setUpwardDataList:array];
    tableView.upwardTitleString = title;
    if (array.count > 8) {
        tableView.heightTableConstraints.constant = 8*40;
    }else{
        
        tableView.heightTableConstraints.constant = (array.count+1) * 40;
    }
    
    QDFWeak(tableView);
    if (finishBlock) {
        [tableView setDidSelectedRow:^(NSString *text,NSInteger row) {
            [tagView removeFromSuperview];
            [weaktableView removeFromSuperview];
            finishBlock(text,row);
        }];
        
        [tableView setDidSelectedButton:^(NSInteger tag) {
            [tagView removeFromSuperview];
            [weaktableView removeFromSuperview];
        }];
    }
}


- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array withTop:(CGFloat)top finishBlock:(void (^)(NSString *, NSInteger))finishBlock
{
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:99998];
    tableView.tableType = @"无";
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.6);
        [self.view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [tagView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
        
        tableView = [UpwardTableView newAutoLayoutView];
        [self.view addSubview:tableView];
        
        
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    }
    
//    if (tagView) {//点击蒙板，界面消失
//        UIButton *control = [UIButton newAutoLayoutView];
//        [tagView addSubview:control];
//        [control autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//        [control autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tableView];
//        [control addAction:^(UIButton *btn) {
//            [tagView removeFromSuperview];
//            [tableView removeFromSuperview];
//        }];
//    }
    
    [tableView setUpwardDataList:array];
    if (array.count > 8) {
        tableView.heightTableConstraints.constant = 8*40;
    }else{
        tableView.heightTableConstraints.constant = array.count*40;
    }
    
    QDFWeak(tableView);
    if (finishBlock) {
        [tableView setDidSelectedRow:^(NSString *text,NSInteger row) {
            [tagView removeFromSuperview];
            [weaktableView removeFromSuperview];
            finishBlock(text,row);
        }];
    }
}

@end
