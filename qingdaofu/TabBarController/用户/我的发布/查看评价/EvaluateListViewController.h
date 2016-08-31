//
//  EvaluateListViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface EvaluateListViewController : NetworkViewController

@property (nonatomic,strong) NSString *typeString;  //发布方,接单方
//@property (nonatomic,strong) NSString *evaString;  //0首次评价；1二次评价,>=2隐藏评价

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;

@end
