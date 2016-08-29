//
//  ReceiptActionCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptActionCell : UITableViewCell

@property (nonatomic,strong) void (^didSelectedActbutton)(NSInteger,UIButton *);

@property (nonatomic,strong) UIButton *reActButton1;
@property (nonatomic,strong) UIButton *reActButton2;
@property (nonatomic,strong) UIButton *reActButton3;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
