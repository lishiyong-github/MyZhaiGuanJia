//
//  ExtendHomeCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/22.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendHomeCell : UITableViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UIButton *nameButton;  //name //清收／诉讼
@property (nonatomic,strong) UIImageView *typeImageView;
@property (nonatomic,strong) UILabel *statusLabel; //发布中，处理中
@property (nonatomic,strong) UIButton *contentButton;  //发布详情

//@property (nonatomic,strong) UIButton *deadLineButton;
//@property (nonatomic,strong) UIButton *actButton1;
@property (nonatomic,strong) UIButton *actButton2;


//@property (nonatomic,strong) UIImageView *closeImage;
//@property (nonatomic,strong) UILabel *nameLabel;
//
//@property (nonatomic,strong) UIButton *typeButton;

@end
