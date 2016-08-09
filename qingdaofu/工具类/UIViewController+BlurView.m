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

@implementation UIViewController (BlurView)

@dynamic didSelectedSingleButton;

//有标题
- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array andTitle:(NSString *)title finishBlock:(void (^)(NSString *text,NSInteger row))finishBlock
{
    [self hiddenBlurView];
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:99998];
    
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        tagView.tag = 99999;
        [view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        tableView = [UpwardTableView newAutoLayoutView];
        tableView.tableType = @"有";
        [tagView addSubview:tableView];
      
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
        }];
    }
    
    if (finishBlock) {
        [tableView setDidSelectedRow:^(NSString *text,NSInteger row) {
            [tagView removeFromSuperview];
            finishBlock(text,row);
        }];
        
        [tableView setDidSelectedButton:^(NSInteger tag) {
            [tagView removeFromSuperview];
        }];
    }
}

//无标题，有topconstraints－－－产品页面的选择功能
- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array withTop:(CGFloat)top finishBlock:(void (^)(NSString *, NSInteger))finishBlock
{
    [self hiddenBlurView];
    UIView *tagView = [self.view viewWithTag:99999];
    UpwardTableView *tableView = [self.view viewWithTag:99998];
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        tagView.tag = 99999;
        if (!view) {
            view = self.view;
        }
        [view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [tagView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
        
        tableView = [UpwardTableView newAutoLayoutView];
        tableView.tableType = @"无";

        [tagView addSubview:tableView];
        
        [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        tableView.heightTableConstraints.constant = array.count*40;
        [tableView setUpwardDataList:array];
    }
    
    if (tagView) {//点击蒙板，界面消失
        UIButton *control = [UIButton newAutoLayoutView];
        [tagView addSubview:control];
        [control autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [control autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tableView];
        [control addAction:^(UIButton *btn) {
            [tagView removeFromSuperview];
        }];
    }
    
    if (finishBlock) {
        [tableView setDidSelectedRow:^(NSString *text,NSInteger row) {
            [tagView removeFromSuperview];
            finishBlock(text,row);
        }];
    }
}

//推荐页面的发布
- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array finishBlock:(void(^)(NSInteger row))finishBlock
{
//    [self hiddenBlurView];
    UIView *tagView = [self.view viewWithTag:99999];
    SingleButton *collectionButton;
    SingleButton *suitButton;

    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0xffffff, 0.9);
        tagView.tag = 99999;
        if (!view) {
            view = self.view;
        }
        [view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        //清收
        collectionButton = [[SingleButton alloc] init];
        collectionButton.center = CGPointMake((kScreenWidth/4), kScreenHeight/2);
        [collectionButton.button setImage:[UIImage imageNamed:@"btn_collection"] forState:0];
        collectionButton.label.text = @"发布清收";
        [tagView addSubview:collectionButton];
        QDFWeakSelf;
        [collectionButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedSingleButton) {
                weakself.didSelectedSingleButton(77);
            }
        }];
        
        //诉讼
        suitButton = [[SingleButton alloc] init];
        suitButton.center = CGPointMake((kScreenWidth/4*3), kScreenHeight/2);
        [suitButton.button setImage:[UIImage imageNamed:@"btn_litigation"] forState:0];
        suitButton.label.text = @"发布诉讼";
        [tagView addSubview:suitButton];
        [suitButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedSingleButton) {
                weakself.didSelectedSingleButton(78);
            }
        }];
        
        //取消按钮
        UIButton *cancelButton = [UIButton newAutoLayoutView];
        [cancelButton setImage:[UIImage imageNamed:@"close"] forState:0];
        [cancelButton addAction:^(UIButton *btn) {
            [tagView removeFromSuperview];
        }];
        [tagView addSubview:cancelButton];
        [cancelButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40];
        
        [UIView animateWithDuration:0.3 animations:^{
            collectionButton.frame = CGRectMake(0, 0, 80, kScreenWidth/4);
            collectionButton.center = CGPointMake((kScreenWidth/4), kScreenHeight/2);
            
            suitButton.frame = CGRectMake(0, 0, 80, kScreenWidth/4);
            suitButton.center = CGPointMake((kScreenWidth/4*3), kScreenHeight/2);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (finishBlock) {
        
        QDFWeakSelf;
        
        [collectionButton addAction:^(UIButton *btn) {
//            if (weakself.didSelectedSingleButton) {
//                weakself.didSelectedSingleButton(77);
//            }
//            [weakself hiddenBlurView];
            
            [tagView removeFromSuperview];

            finishBlock(77);
        
        }];
        
        [suitButton addAction:^(UIButton *btn) {
//            if (weakself.didSelectedSingleButton) {
//                weakself.didSelectedSingleButton(78);
//            }
//            [weakself hiddenBlurView];
            
            [tagView removeFromSuperview];
            finishBlock(78);

        }];
        
    }
    
//    if (finishBlock) {
//    }

        /*
    NewPublishCell *cell;
    if (!tagView) {
        tagView = [UIView newAutoLayoutView];
        tagView.backgroundColor = UIColorFromRGB1(0x333333, 0.8);
        tagView.tag = 99999;
        if (!view) {
            view = self.view;
        }
        [view addSubview:tagView];
        [tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

        cell = [NewPublishCell newAutoLayoutView];
        [cell.financeButton.label setTextColor:kNavColor];
        [cell.collectionButton.label setTextColor:kNavColor];
        [cell.suitButton.label  setTextColor:kNavColor];
        [tagView addSubview:cell];
        
        UIButton *cancelButton = [UIButton newAutoLayoutView];
        [cancelButton setImage:[UIImage imageNamed:@"btn_close"] forState:0];
        [cancelButton addAction:^(UIButton *btn) {
            [tagView removeFromSuperview];
        }];
        [tagView addSubview:cancelButton];
        
        [cell autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [cell autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [cell autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [cell autoSetDimension:ALDimensionHeight toSize:115];
        
        [cancelButton autoAlignAxis:ALAxisVertical toSameAxisOfView:cell];
        [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40];
    }
    
    if (finishBlock) {
        [cell setDidSelectedItem:^(NSInteger item) {
            [tagView removeFromSuperview];
            if (item == 11) {//融资
                finishBlock(11);
            }else if (item == 12){//清收
                finishBlock(12);
            }else if (item == 13){//诉讼
                finishBlock(13);
            }
        }];
    }
     */
}


- (void)hiddenBlurView
{
    UIView *tagView = [self.view viewWithTag:99999];
    [tagView removeFromSuperview];
}


@end
