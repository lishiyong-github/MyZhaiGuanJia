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
#import "SingleButton.h"
#import "NewPublishCell.h"

@implementation UIViewController (BlurView)

//有标题
- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array andTitle:(NSString *)title finishBlock:(void (^)(NSString *text,NSInteger row))finishBlock
{
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:99998];
    
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        [self.view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        tableView = [UpwardTableView newAutoLayoutView];
        tableView.tableType = @"有";
        [self.view addSubview:tableView];
      
        [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        if (array.count > 7) {
            tableView.heightTableConstraints.constant = 6*40;
        }else{
            tableView.heightTableConstraints.constant = (array.count+1) * 40;
        }
        [tableView setUpwardDataList:array];
        tableView.upwardTitleString = title;
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

//无标题，有topconstraints－－－产品页面的选择功能
- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array withTop:(CGFloat)top finishBlock:(void (^)(NSString *, NSInteger))finishBlock
{
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:99998];
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.7);
        [self.view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [tagView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
        
        tableView = [UpwardTableView newAutoLayoutView];
        tableView.tableType = @"无";
        [self.view addSubview:tableView];
        
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        tableView.heightTableConstraints.constant = array.count*40;
        [tableView setUpwardDataList:array];
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

//推荐页面的发布
- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array finishBlock:(void(^)(NSString *text,NSInteger row))finishBlock
{
    UIView *tagView = [self.view viewWithTag:99999];
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.6);
        [self.view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
//        SingleButton *financeButton = [SingleButton newAutoLayoutView];
//        [financeButton.button setImage:[UIImage imageNamed:@""] forState:0];
//        [financeButton.label setText:@"发布融资"];
//        [self.view addSubview:financeButton];
//        
//        SingleButton *collectButton = [SingleButton newAutoLayoutView];
//        [financeButton.button setImage:[UIImage imageNamed:@""] forState:0];
//        [financeButton.label setText:@"发布清收"];
//        [self.view addSubview:collectButton];
//        
//        SingleButton *suitButton = [SingleButton newAutoLayoutView];
//        [financeButton.button setImage:[UIImage imageNamed:@""] forState:0];
//        [financeButton.label setText:@"发布诉讼"];
//        [self.view addSubview:suitButton];
        
//        NewPublishCell *cell = [NewPublishCell newAutoLayoutView];
//        [self.view addSubview:cell];
//        
//        [cell autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//        [cell autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        [cell autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }
}


- (void)hiddenBlurView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *tagView = [window viewWithTag:99999];
//    [self.view viewWithTag:99999];
    UIView *tableView = [window viewWithTag:99998];
//    [self.view viewWithTag:99998];
    [tagView removeFromSuperview];
    [tableView removeFromSuperview];
}


@end
