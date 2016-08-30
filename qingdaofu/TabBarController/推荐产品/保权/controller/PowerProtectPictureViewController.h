//
//  PowerProtectPictureViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "PowerModel.h"
#import "ApplicationModel.h"

@interface PowerProtectPictureViewController : NetworkViewController

@property (nonatomic,strong) NSString *navTitleString;//保全，保函（因为两个model不一样）
@property (nonatomic,strong) PowerModel *pModel;//保全
@property (nonatomic,strong) ApplicationModel *aModel; //保函

@end
