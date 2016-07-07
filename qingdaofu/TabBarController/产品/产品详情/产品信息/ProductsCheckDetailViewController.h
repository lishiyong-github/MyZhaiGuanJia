//
//  ProductsCheckDetailViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductsCheckDetailViewController : BaseViewController

@property (nonatomic,strong) NSString *categoryString;  //1债权人信息，2债务人信息
@property (nonatomic,strong) NSArray *listArray;

@end