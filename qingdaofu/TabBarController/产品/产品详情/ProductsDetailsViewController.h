//
//  ProductsDetailsViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface ProductsDetailsViewController : NetworkViewController

@property (nonatomic,strong) void (^didRefreshNewProduct)(BOOL);
@property (nonatomic,strong) NSString *productid;

@end
