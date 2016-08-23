//
//  OrderPublishCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/23.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPublishCell : UITableViewCell

@property (nonatomic,strong) UIButton *checkButton;
@property (nonatomic,strong) UILabel *listLabel;
@property (nonatomic,strong) UIButton *contactButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
