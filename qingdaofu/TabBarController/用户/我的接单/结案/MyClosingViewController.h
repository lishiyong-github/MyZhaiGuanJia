//
//  MyClosingViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface MyClosingViewController : NetworkViewController

@property (nonatomic,strong) NSString *evaString; //0首次评价，1二次评价，>=2不评价

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categaryString;
@property (nonatomic,strong) NSString *pidString;


@end
