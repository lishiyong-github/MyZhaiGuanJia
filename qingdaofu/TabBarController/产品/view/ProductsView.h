//
//  ProductsView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/15.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsView : UIView

@property (nonatomic,strong) void (^didSelectedBtn)(NSInteger);

@property (nonatomic,strong) UIButton *collectionButton;
@property (nonatomic,strong) UIButton *suitButton;
@property (nonatomic,strong) UILabel *kLabel;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSLayoutConstraint *leftConstraints;
@end
