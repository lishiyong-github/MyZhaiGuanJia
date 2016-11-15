//
//  AgreementViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface AgreementViewController : NetworkViewController

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *pidString;


//////
@property (nonatomic,strong) NSString *navTitleString;  //标题
@property (nonatomic,strong) NSString *flagString; //1为有同意按钮  0为无
@property (nonatomic,strong) NSString *productid;
@property (nonatomic,strong) NSString *ordersid;

@end
