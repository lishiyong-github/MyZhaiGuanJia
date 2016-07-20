//
//  NewsTableViewCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *newsNameButton;
@property (nonatomic,strong) UIButton *newsCountButton;
@property (nonatomic,strong) UIButton *newsActionButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

- (void)swapUserName;

@end
