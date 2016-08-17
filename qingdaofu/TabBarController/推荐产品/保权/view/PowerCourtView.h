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
@property (nonatomic,strong) NSString *typeComponent;
@property (nonatomic,strong) NSMutableArray *component1;
@property (nonatomic,strong) NSMutableArray *component2;

@property (nonatomic,strong) UIButton *finishButton;
@property (nonatomic,strong) UIPickerView *pickerViews;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
