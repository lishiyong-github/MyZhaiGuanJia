//
//  ProductsDetailsViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface ProductsDetailsViewController : NetworkViewController

@property (nonatomic,strong) NSLayoutConstraint *leftCommitConstraints;

//产品ID
@property (nonatomic,strong) NSString *idString;
//产品类型
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *pidString;

@end
