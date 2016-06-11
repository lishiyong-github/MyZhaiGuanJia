//
//  NetworkViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "AFNetworking.h"

@interface NetworkViewController : BaseViewController

/*
-(void)requestDataGetWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void(^)())successBlock andFailBlock:(void(^)())failBlock;
*/
-(void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void(^)())successBlock andFailBlock:(void(^)())failBlock;

//-(void)showMBProgressHUDText:(NSString *)text;

@end
