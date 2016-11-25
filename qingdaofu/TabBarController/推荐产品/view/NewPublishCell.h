//
//  NewPublishCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingleButton.h"

//95+18
@interface NewPublishCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) SingleButton *functionButton1;
@property (nonatomic,strong) SingleButton *functionButton2;
@property (nonatomic,strong) SingleButton *functionButton3;
@property (nonatomic,strong) SingleButton *functionButton4;

@property (nonatomic,strong) void (^didSelectedItem)(NSInteger);

@end
