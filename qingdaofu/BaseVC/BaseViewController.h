//
//  BaseViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIBarButtonItem *leftItem;
@property (nonatomic,strong) UIImageView *baseRemindImageView;


- (NSString *)getValidateToken;
- (NSString *)getValidateMobile;
- (void)back;

@end
