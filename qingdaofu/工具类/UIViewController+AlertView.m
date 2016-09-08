//
//  UIViewController+AlertView.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIViewController+AlertView.h"

@implementation UIViewController (AlertView)

- (void)showAlertViewWithType:(NSString *)type
{
    
    if ([type integerValue] == 1) {//image+label+button
        UIView *backView = [self.view viewWithTag:888];
        UIView *showView = [self.view viewWithTag:889];
        
        if (!backView) {
            backView = [UIView newAutoLayoutView];
            backView.tag = 888;
            backView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:backView];
            [backView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            
            showView = [UIView newAutoLayoutView];
            showView.backgroundColor = kNavColor;
            showView.layer.cornerRadius = corner1;
            [backView addSubview:showView];
            [showView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [showView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [showView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];
            [showView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
            [showView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200];
            [showView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:200];
            
            UIButton *seeButton = [UIButton newAutoLayoutView];
            [seeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [showView addSubview:seeButton];
            [seeButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
//            [seeImageView autoSetDimension:ALDimensionHeight toSize:150];
            
            UIButton *seeButton1 = [UIButton newAutoLayoutView];
            seeButton1.backgroundColor = kNavColor;
            seeButton1.titleLabel.font = kSecondFont;
            [seeButton1 setTitleColor:kBlackColor forState:0];
            [seeButton1 setTitle:@"尊上，请您确定您填写的地址与产证地址一致，若因填写地址模糊错误导致无法拉取产调，小管家收取人工费15元" forState:0];
            seeButton1.titleLabel.numberOfLines = 0;
            seeButton1.contentEdgeInsets = UIEdgeInsetsMake(0, kSpacePadding, 0, kSpacePadding);
            seeButton1.contentHorizontalAlignment = 1;
            [showView addSubview:seeButton1];
            [seeButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [seeButton1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [seeButton1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:seeButton withOffset:kBigPadding];
            
            UIButton *seeButton2 = [UIButton newAutoLayoutView];
            seeButton2.backgroundColor = kNavColor;
            seeButton2.titleLabel.font = kBigFont;
            [seeButton2 setTitleColor:kBlueColor forState:0];
            [seeButton2 setTitle:@"朕知道了" forState:0];
            [showView addSubview:seeButton2];
            
            [seeButton2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:seeButton1];
            [seeButton2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [seeButton2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
//            [seeButton2 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//            [seeButton2 autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        }
        
    }else if([type integerValue] == 2){//label+label+button
        
    }
}

@end
