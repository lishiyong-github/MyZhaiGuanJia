//
//  PowerCourtView.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourtProvinceModel.h"

@interface PowerCourtView : UIView

@property (nonatomic,strong) void (^didSelectdRow)(NSInteger,NSInteger,CourtProvinceModel *);
@property (nonatomic,strong) void (^didSelectedComponent)(NSInteger,NSInteger,NSString *,NSString *); //component,row,id,name

@property (nonatomic,strong) NSString *typeComponent;
@property (nonatomic,strong) NSMutableArray *component1;
@property (nonatomic,strong) NSMutableArray *component2;
@property (nonatomic,strong) NSMutableArray *component3;

//发布产品里面的选择区域
@property (nonatomic,strong) NSDictionary *componentDic1;
@property (nonatomic,strong) NSDictionary *componentDic2;
@property (nonatomic,strong) NSDictionary *componentDic3;
@property (nonatomic,strong) NSString *publishStr;  //3-3列，其他为2列

@property (nonatomic,strong) UIButton *finishButton;
@property (nonatomic,strong) UIPickerView *pickerViews;
@property (nonatomic,strong) UIControl *controllio;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
