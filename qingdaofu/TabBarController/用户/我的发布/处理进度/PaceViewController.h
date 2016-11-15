//
//  PaceViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface PaceViewController : NetworkViewController

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *existence; // 1-不显示添加进度按钮，2-显示

@property (nonatomic,strong) NSString *processid;
@property (nonatomic,strong) NSString *isShowed;  //是否显示添加按钮

@end
