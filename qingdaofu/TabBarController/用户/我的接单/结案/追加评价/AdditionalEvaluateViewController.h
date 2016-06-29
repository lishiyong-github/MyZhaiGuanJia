//
//  AdditionalEvaluateViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"

@interface AdditionalEvaluateViewController : NetworkViewController

@property (nonatomic,strong) NSString *typeString;  //发布方,接单方

@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *categoryString;
@property (nonatomic,strong) NSString *codeString;

@end
