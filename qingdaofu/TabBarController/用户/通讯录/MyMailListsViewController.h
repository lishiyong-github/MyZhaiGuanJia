//
//  MyMailListsViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface MyMailListsViewController : NetworkViewController

@property (nonatomic,strong) NSString *mailType;  //1-从用户进入  2-从经办人进入

@property (nonatomic,strong) NSString *ordersid;

@end
