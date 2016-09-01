//
//  ReceiptAddressViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface ReceiptAddressViewController : NetworkViewController

@property (nonatomic,strong) void (^didSelectedReceiptAddress)(NSString *,NSString*,NSString*);//name  phone address
@property (nonatomic,strong) NSString *cateString;//1-单元格可点击，其余不可点击

@end
