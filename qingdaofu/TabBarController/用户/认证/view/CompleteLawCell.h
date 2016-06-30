//
//  CompleteLawCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletePhotoView.h"

@interface CompleteLawCell : UITableViewCell

@property (nonatomic,strong) UILabel *comNameLabel;//名称
@property (nonatomic,strong) UILabel *comIDLabel;//ID

@property (nonatomic,strong) UILabel *comPicLabel;
@property (nonatomic,strong) UIButton *comPicButton;

@property (nonatomic,strong) UILabel *comPersonNameLabel;  //联系人
@property (nonatomic,strong) UILabel *comPersonTelLabel;//联系方式
@property (nonatomic,strong) UILabel *comMailLabel;  //邮箱
@property (nonatomic,strong) UILabel *comExampleLabel;  //案例
@property (nonatomic,strong) UILabel *comExampleLabel2;//具体案例

@property (nonatomic,strong) UIButton *comImageButton;

@property (nonatomic,assign) BOOL didSetupConstraints;


@end
