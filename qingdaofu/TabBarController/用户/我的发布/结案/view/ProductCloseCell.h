//
//  ProductCloseCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCloseCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic,strong) void (^didselectedBtn)(NSInteger);

@property (nonatomic,strong) NSMutableArray *signImageArray; //签约协议图片

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIImageView *topSpaceImaegView;  //顶部分割线
@property (nonatomic,strong) UILabel *codeLabel; //单号
@property (nonatomic,strong) UIButton *closeProofButton;  //结清证明
@property (nonatomic,strong) UILabel *productTitleLabel;   //产品详情
@property (nonatomic,strong) UIButton *productTextButton;   //产品详情
@property (nonatomic,strong) UIButton *productCheckbutton;  //查看更多
@property (nonatomic,strong) UILabel *signTitleLabel;  //签约协议
@property (nonatomic,strong) UIButton *signTextButton;  //签约协议详情
@property (nonatomic,strong) UIButton *signPictureButton1;//签约协议图片
@property (nonatomic,strong) UIScrollView *signDetailScrollView;  //具体签约协议


@property (nonatomic,strong) UIButton *sighCheckButton;  //查看更多协议
@property (nonatomic,strong) UILabel *investLabel;  //尽职调查
@property (nonatomic,strong) UIButton *investCheckButton; // 查看尽职调查
@property (nonatomic,strong) UILabel *agreementLabel;  //居间协议
@property (nonatomic,strong) UIButton *agreementCheckButton;  //查看居间协议

//分割线
@property (nonatomic,strong) UILabel *line1;
@property (nonatomic,strong) UILabel *line2;
@property (nonatomic,strong) UILabel *line3;
@property (nonatomic,strong) UILabel *line4;
@property (nonatomic,strong) UILabel *line5;
@property (nonatomic,strong) UILabel *line6;


@end
