//
//  UIViewController+BlurView.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BlurView)

//@property (nonatomic,strong) UIView *tagView;
//@property (nonatomic,strong) UpwardTableView *tableView;

//- (void)showBlurWith:(NSArray *)array andTitle:(NSString *)title finishBlock:(void(^)(NSString *text))finishBlock;

- (void)showBlurInView:(UIView *)view withArray:(NSArray *)array andTitle:(NSString *)title finishBlock:(void(^)(NSString *text,NSInteger row))finishBlock;

@end
