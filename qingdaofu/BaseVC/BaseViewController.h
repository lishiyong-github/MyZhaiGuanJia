//
//  BaseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIBarButtonItem *leftItem;

- (NSString *)getValidateToken;

@end
