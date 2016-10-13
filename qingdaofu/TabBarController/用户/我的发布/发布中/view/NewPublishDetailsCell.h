//
//  NewPublishDetailsCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPublishDetailsCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) UIButton *point1;//第一步
@property (nonatomic,strong) UIButton *point2;//第二步
@property (nonatomic,strong) UIButton *point3;//第三步
@property (nonatomic,strong) UIButton *point4;//第四步

@property (nonatomic,strong) UILabel *progress1;//发布成功
@property (nonatomic,strong) UILabel *progress2;//面谈中
@property (nonatomic,strong) UILabel *progress3;//订单处理
@property (nonatomic,strong) UILabel *progress4;//结案

@property (nonatomic,strong) UILabel *line1;//分割线
@property (nonatomic,strong) UILabel *line2;
@property (nonatomic,strong) UILabel *line3;

@end
