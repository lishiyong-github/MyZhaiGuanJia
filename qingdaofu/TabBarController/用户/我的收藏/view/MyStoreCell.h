//
//  MyStoreCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStoreCell : UITableViewCell

@property (nonatomic,strong) UIButton *sButton1;
@property (nonatomic,strong) UIButton *sButton2;

//@property (nonatomic,strong) UIImageView *imageView1;
//@property (nonatomic,strong) UILabel *label1;
//@property (nonatomic,strong) UILabel *label2;
//@property (nonatomic,strong) UILabel *label3;
//@property (nonatomic,strong) UIButton *button1;

@property (nonatomic,assign) BOOL didSetupConstraints;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
