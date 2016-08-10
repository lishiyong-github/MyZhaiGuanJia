//
//  ApplicationGuaranteeSecondView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/9.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationGuaranteeSecondView : UIView

@property (nonatomic,strong) void (^didSelectedRow)(NSInteger);
@property (nonatomic,strong) UITableView *tableViewa;

@property (nonatomic,assign) BOOL didSrtupConstraints;

@end
