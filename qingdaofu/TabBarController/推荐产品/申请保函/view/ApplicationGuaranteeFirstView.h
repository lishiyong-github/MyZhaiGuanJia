//
//  ApplicationGuaranteeFirstView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationGuaranteeFirstView : UIView
@property (nonatomic,strong) void (^didSelectedRow)(NSInteger);
@property (nonatomic,strong) void (^didEndEditting)(NSString *,NSInteger);
@property (nonatomic,copy) void (^touchBeginPoint)(CGPoint);

@property (nonatomic,strong) UITableView *tableViewa;
@property (nonatomic,assign) BOOL chooseTag;  //需要改变收货地址的变量

@property (nonatomic,assign) BOOL didSrtupConstraints;

@end
