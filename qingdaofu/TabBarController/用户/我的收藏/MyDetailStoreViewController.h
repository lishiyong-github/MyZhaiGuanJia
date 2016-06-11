//
//  MyDetailStoreViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface MyDetailStoreViewController : NetworkViewController
//产品ID
@property (nonatomic,strong) NSString *idString;
//产品类型
@property (nonatomic,strong) NSString *categoryString;
@end
