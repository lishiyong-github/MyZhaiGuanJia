//
//  BrandsViewController.h
//  qingdaofu
//
//  Created by shiyong_li on 16/6/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface BrandsViewController : NetworkViewController

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) void (^didSelectedRow)(NSInteger,NSString *);
@end
