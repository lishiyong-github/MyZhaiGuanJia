//
//  CompleteCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletePhotoView.h"
#import "EditDebtAddressCell.h"
#import "TakePictureCell.h"

@interface CompleteCell : UITableViewCell

@property (nonatomic,strong) UILabel *comNameLabel;//名称
@property (nonatomic,strong) UILabel *comIDLabel;//ID
//@property (nonatomic,strong) CompletePhotoView *comPhotoView;  //图片
@property (nonatomic,strong) UILabel *comPicLabel;
@property (nonatomic,strong) UIButton *comPicButton;

@property (nonatomic,strong) UILabel *comMailLabel;  //邮箱
@property (nonatomic,strong) UILabel *comExampleLabel;  //案例
@property (nonatomic,strong) UILabel *comExampleLabel2;//具体案例

@property (nonatomic,strong) UIButton *comImageButton;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
